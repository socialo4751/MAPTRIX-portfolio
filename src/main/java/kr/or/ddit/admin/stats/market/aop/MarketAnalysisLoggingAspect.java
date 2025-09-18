package kr.or.ddit.admin.stats.market.aop;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.admin.stats.market.geo.GidIndexVO;
import kr.or.ddit.admin.stats.market.geo.GidLookupService;
import kr.or.ddit.admin.stats.market.service.LogMarketAnalysisService;
import kr.or.ddit.admin.stats.market.vo.LogMarketAnalysisVO;
import kr.or.ddit.market.simple.dto.request.AiRequestDto;
import lombok.RequiredArgsConstructor;

@Aspect
@Component
@RequiredArgsConstructor
public class MarketAnalysisLoggingAspect {

    private final LogMarketAnalysisService logService;
    private final ObjectMapper objectMapper;
    private final GidLookupService gidLookupService; // ★ DB 룩업

    @Around("@annotation(marketLog)")
    public Object logAnalysis(ProceedingJoinPoint pjp, MarketLog marketLog) throws Throwable {
        long t0 = System.nanoTime();
        String status = "SUCCESS";
        int resultRows = -1;

        HttpServletRequest req = currentRequest();
        String userId = currentUserId();
        String ip      = clientIp(req);
        String channel = detectChannel(req);

        Object result = null;
        try {
            result = pjp.proceed();

            Object body = (result instanceof ResponseEntity<?> re) ? re.getBody() : result;
            resultRows = estimateCount(body);

            // ★★★ 여기 추가: 본문/HTTP 코드 기반으로 상태 재판단
            status = inferStatus(result);
            if (status == null) status = "SUCCESS";

            return result;

        } catch (Throwable t) {
            status = "FAIL";
            throw t;

        } finally {
            LogMarketAnalysisVO log = new LogMarketAnalysisVO();
            log.setUserId(userId);
            log.setAnalysisType(marketLog.value());
            log.setClientIp(ip);
            log.setChannel(channel);
            log.setResultRows(resultRows >= 0 ? (long) resultRows : null);
            log.setDurationMs(TimeUnit.NANOSECONDS.toMillis(System.nanoTime() - t0));
            log.setStatus(status);

            if ("SIMPLE".equalsIgnoreCase(marketLog.value())) {
                fillSimpleFields(pjp, req, log);
            } else if ("DETAIL".equalsIgnoreCase(marketLog.value())) {
                fillDetailFields(pjp, req, log);
            }

            try { logService.logMarketAnalysis(log); } catch (Exception ignore) {}
        }
    }

    /** 결과 객체에서 성공/실패를 추론: 실패면 "FAIL", 성공이면 "SUCCESS", 판단 못하면 null */
    private String inferStatus(Object result) {
        if (result == null) return "FAIL";

        if (result instanceof ResponseEntity<?> re) {
            // HTTP 코드 우선
            if (!re.getStatusCode().is2xxSuccessful()) return "FAIL";
            return inferStatusFromBody(re.getBody());
        }
        return inferStatusFromBody(result);
    }

    /** 본문 내용으로 성공/실패 추론 (DTO/Map/String 모두 커버) */
    @SuppressWarnings("unchecked")
    private String inferStatusFromBody(Object body) {
        if (body == null) return "FAIL";

        // 1) Map인 경우: success/status/error 관례값 체크
        if (body instanceof Map<?,?> m) {
            if (m.containsKey("success")) {
                Boolean b = coerceBool(m.get("success"));
                if (b != null) return b ? "SUCCESS" : "FAIL";
            }
            if (m.containsKey("status")) {
                String s = String.valueOf(m.get("status")).trim().toUpperCase();
                if ("SUCCESS".equals(s) || "OK".equals(s)) return "SUCCESS";
                if ("FAIL".equals(s) || "ERROR".equals(s)) return "FAIL";
            }
            if (m.containsKey("error") || m.containsKey("errorCode")) return "FAIL";
            // 판단 불가 → null
            return null;
        }

        // 2) 문자열인 경우: SUCCESS/FAIL/ERROR 키워드
        if (body instanceof CharSequence cs) {
            String s = cs.toString().trim();
            String u = s.toUpperCase();
            if ("SUCCESS".equals(u) || "OK".equals(u)) return "SUCCESS";
            if ("FAIL".equals(u) || "ERROR".equals(u) || u.contains("ERROR")) return "FAIL";
            return null;
        }

        // 3) DTO인 경우: success / ok / status 게터를 리플렉션으로 탐색
        try {
            // (a) boolean success / ok
            for (String m : new String[]{"isSuccess","getSuccess","isOk","getOk"}) {
                try {
                    var meth = body.getClass().getMethod(m);
                    Object val = meth.invoke(body);
                    Boolean b = coerceBool(val);
                    if (b != null) return b ? "SUCCESS" : "FAIL";
                } catch (NoSuchMethodException ignore) {}
            }
            // (b) status 문자열
            for (String m : new String[]{"getStatus"}) {
                try {
                    var meth = body.getClass().getMethod(m);
                    Object val = meth.invoke(body);
                    if (val != null) {
                        String s = String.valueOf(val).trim().toUpperCase();
                        if ("SUCCESS".equals(s) || "OK".equals(s)) return "SUCCESS";
                        if ("FAIL".equals(s) || "ERROR".equals(s)) return "FAIL";
                    }
                } catch (NoSuchMethodException ignore) {}
            }
            // (c) error / errorCode 존재 여부
            // DTO → Map으로 변환해 1) 로직 재사용
            Map<String,Object> asMap = objectMapper.convertValue(body, Map.class);
            return inferStatusFromBody(asMap);
        } catch (Exception ignore) {
            return null;
        }
    }

    /** true/false, "Y"/"N", "true"/"false", 1/0 등을 Boolean으로 강제 변환 */
    private Boolean coerceBool(Object v) {
        if (v == null) return null;
        if (v instanceof Boolean b) return b;
        if (v instanceof Number n) return n.intValue() != 0;
        String s = String.valueOf(v).trim().toUpperCase();
        if ("Y".equals(s) || "YES".equals(s) || "TRUE".equals(s) || "OK".equals(s)) return true;
        if ("N".equals(s) || "NO".equals(s)  || "FALSE".equals(s) || "FAIL".equals(s) || "ERROR".equals(s)) return false;
        return null;
    }

    /* ======================= SIMPLE (수정된 부분) ======================= */
    private void fillSimpleFields(ProceedingJoinPoint pjp, HttpServletRequest req, LogMarketAnalysisVO log) {
        // [기존] 파라미터 이름과 값 매핑
        var ms = (MethodSignature) pjp.getSignature();
        String[] names = ms.getParameterNames();
        Object[] args = pjp.getArgs();
        Map<String, Object> byName = new LinkedHashMap<>();
        if (names != null) {
            for (int i = 0; i < Math.min(names.length, args.length); i++) {
                byName.put(names[i], args[i]);
            }
        }

        // [기존] HTTP 요청 파라미터에서 값 추출 시도
        String admCode = strOrNull(byName.get("admCode"), req != null ? req.getParameter("admCode") : null);
        String bizCodeId = strOrNull(byName.get("bizCodeId"), req != null ? req.getParameter("bizCodeId") : null);
        
        // [신규] @RequestBody로 받은 AiRequestDto에서 admCode, bizCodeId를 추출하는 로직
        // 만약 기존 방식으로 값을 찾지 못했다면 DTO를 확인합니다.
        if (admCode == null || bizCodeId == null) {
            for (Object arg : args) {
                if (arg instanceof AiRequestDto dto) {
                    // AiRequestDto에서 분석 결과를 담고 있는 Map을 가져옵니다.
                    Map<String, Object> analysisResult = dto.getAnalysisResult();
                    if (analysisResult != null) {
                        // Map 내부에서 admCode와 bizCodeId를 다시 추출합니다.
                        // 이 값들은 클라이언트가 AI 분석 요청 시 함께 보낸 원본 데이터입니다.
                        if (admCode == null) {
                            admCode = optString(analysisResult.get("admCode"));
                        }
                        if (bizCodeId == null) {
                            bizCodeId = optString(analysisResult.get("bizCodeId"));
                        }
                    }
                    break; // DTO를 찾았으므로 반복 중단
                }
            }
        }
        
        // [기존] 나머지 파라미터 추출
        String bizLevel   = strOrNull(byName.get("bizLevel"),   req != null ? req.getParameter("bizLevel")   : null);
        String year       = strOrNull(byName.get("year"),       req != null ? req.getParameter("year")       : null);
        String districtId = strOrNull(byName.get("districtId"), req != null ? req.getParameter("districtId") : null);
        String geomWkt    = strOrNull(byName.get("geomWkt"),    req != null ? req.getParameter("geomWkt")    : null);

        // [수정] 추출된 admCode와 bizCodeId를 로그 객체에 최종 설정
        log.setAdmCode(admCode);
        log.setBizCodeId(bizCodeId);
        log.setGeomWkt(geomWkt);

        // [기존] paramJson 생성
        Map<String, Object> params = new LinkedHashMap<>();
        params.put("admCode", admCode);
        params.put("bizCodeId", bizCodeId);
        params.put("bizLevel", bizLevel);
        params.put("year", year);
        params.put("districtId", districtId);
        if (geomWkt != null) params.put("geomWkt", "WKT(" + geomWkt.length() + ")");
        log.setParamJson(toJsonSafe(params));

        // [기존] contextJson 생성
        Map<String, Object> ctx = Map.of(
            "method", ms.getMethod().getName(),
            "type", "SIMPLE"
        );
        log.setContextJson(toJsonSafe(ctx));
    }

    /* ======================= DETAIL (수정 핵심) ======================= */
    private void fillDetailFields(ProceedingJoinPoint pjp, HttpServletRequest req, LogMarketAnalysisVO log) {
        var ms = (MethodSignature) pjp.getSignature();
        String method = ms.getMethod().getName();
        String subType = switch (method) {
            case "analyzeGrid"         -> "GRID";
            case "analyzeClusterGrid"  -> "CLUSTER";
            case "analyzeLogisticGrid" -> "LOGISTIC";
            case "analyzeGravityGrid"  -> "GRAVITY";
            default -> "DETAIL";
        };

        // 요청 바디 DTO를 요약 (gid 등 뽑힘)
        Map<String, Object> summary = summarizeDetailArgs(pjp.getArgs());
        String gid = optString(summary.get("gid"));
        if (gid == null && req != null) gid = optString(req.getParameter("gid"));

        // ★ DB에서 gid → (admCode, districtId) 조회
        if (gid != null && !gid.isBlank()) {
            Optional<GidIndexVO> infoOpt = gidLookupService.findByGid(gid);
            if (infoOpt.isPresent()) {
                GidIndexVO info = infoOpt.get();
                if (info.getAdmCode() != null && !info.getAdmCode().isBlank()) {
                    log.setAdmCode(info.getAdmCode());           // INSERT에 포함되면 그대로 저장
                    summary.put("admCodeFromGid", info.getAdmCode()); // param_json에도 흔적 남김(옵션)
                }
                if (info.getDistrictId() != null) {
                    log.setDistrictId(info.getDistrictId());     // VO에 있으면 직접 세팅
                    summary.put("districtIdFromGid", info.getDistrictId());
                }
            }
        }

        log.setParamJson(toJsonSafe(summary));

        Map<String, Object> ctx = new LinkedHashMap<>();
        ctx.put("method", method);
        ctx.put("type", "DETAIL");
        ctx.put("subType", subType);
        if (req != null) ctx.put("ua", optString(req.getHeader("User-Agent")));
        log.setContextJson(toJsonSafe(ctx));
    }

    private Map<String, Object> summarizeDetailArgs(Object[] args) {
        // 대표 키만 추출
        Set<String> whitelist = Set.of(
            "gid","year","gridSize","k","threshold","bizCodeId","admCode",
            "featureCount","sampleCount","geomWkt"
        );
        Map<String, Object> out = new LinkedHashMap<>();
        for (Object a : args) {
            if (a == null || a instanceof HttpServletRequest) continue;
            try {
                Map<?,?> m = objectMapper.convertValue(a, Map.class);
                for (Map.Entry<?,?> e : m.entrySet()) {
                    String key = String.valueOf(e.getKey());
                    Object val = e.getValue();
                    if (!whitelist.contains(key) || val == null) continue;

                    if (val instanceof Collection<?> c) {
                        out.putIfAbsent(key, "LIST(" + c.size() + ")");
                    } else {
                        String s = String.valueOf(val);
                        out.putIfAbsent(key, s.length() > 200 ? s.substring(0,200) + "...(" + s.length() + ")" : val);
                    }
                }
            } catch (IllegalArgumentException ignore) {
                out.putIfAbsent(a.getClass().getSimpleName(), "DTO");
            }
        }
        return out;
    }

    /* ======================= 공통 유틸 ======================= */
    private HttpServletRequest currentRequest() {
        var attrs = RequestContextHolder.getRequestAttributes();
        return (attrs instanceof ServletRequestAttributes sra) ? sra.getRequest() : null;
    }

    private String currentUserId() {
        Authentication a = SecurityContextHolder.getContext().getAuthentication();
        if (a == null || !a.isAuthenticated()) return null;
        String name = a.getName();
        return "anonymousUser".equalsIgnoreCase(name) ? null : name;
    }
    

    private String clientIp(HttpServletRequest req) {
        if (req == null) return null;
        String xff = req.getHeader("X-Forwarded-For");
        return (xff != null && !xff.isBlank()) ? xff.split(",")[0].trim() : req.getRemoteAddr();
    }

    private String detectChannel(HttpServletRequest req) {
        if (req == null) return "WEB";
        String ua = optString(req.getHeader("User-Agent")).toLowerCase();
        return (ua.contains("mobile") || ua.contains("android") || ua.contains("iphone")) ? "MOBILE" : "WEB";
    }

    private int estimateCount(Object body) {
        if (body == null) return -1;
        if (body instanceof Collection<?> c) return c.size();
        if (body instanceof Map<?,?> m) {
            for (String k : List.of("list","rows","data")) {
                Object v = m.get(k);
                if (v instanceof Collection<?> lc) return lc.size();
            }
            return m.size();
        }
        return 1;
    }

    private String strOrNull(Object first, String fallback) {
        if (first != null) {
            String s = String.valueOf(first);
            if (!s.isBlank()) return s;
        }
        return (fallback != null && !fallback.isBlank()) ? fallback : null;
    }

    private String optString(Object o) {
        if (o == null) return null;
        String s = String.valueOf(o);
        return s.isBlank() ? null : s;
    }

    private String toJsonSafe(Object o) {
        try { return objectMapper.writeValueAsString(o); }
        catch (Exception e) { return null; }
    }
}
