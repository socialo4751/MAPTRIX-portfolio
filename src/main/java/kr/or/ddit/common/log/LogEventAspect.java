package kr.or.ddit.common.log;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.admin.stats.user.vo.LogUserEventVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.lang.reflect.Method;

/**
 * 요청 스레드에서 모든 값을 채워 LogUserEventVO에 담고,
 * 비동기 Writer(LogEventWriter)로 전달하는 AOP.
 */
@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class LogEventAspect {

    private final LogEventWriter logEventWriter;
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    @Around("@annotation(kr.or.ddit.common.log.LogEvent)")
    public Object logEvent(ProceedingJoinPoint pjp) throws Throwable {
        long t0 = System.currentTimeMillis();

        // 1) 주체/요청 정보 (요청 스레드에서 확보)
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String userId = resolveUserId(auth);

        HttpServletRequest req = resolveRequest();
        String clientIp = resolveClientIp(req);
        String channel  = resolveChannel(req);

        // 2) 애노테이션 추출 (프록시/인터페이스 대응)
        MethodSignature sig = (MethodSignature) pjp.getSignature();
        LogEvent ann = resolveAnnotation(pjp, sig);

        String eventType = (ann != null && ann.eventType() != null) ? ann.eventType() : "ACTION";
        String feature   = (ann != null && ann.feature()   != null) ? ann.feature()   : "OTHER";

        String paramJson = safeJson(pjp.getArgs()); // 필요 시 길이/마스킹 처리
        String status = "SUCCESS";
        Long resultRows = null;

        Object ret;
        try {
            ret = pjp.proceed();
            if (ret instanceof java.util.Collection<?> col) resultRows = (long) col.size();
            return ret;
        } catch (Throwable ex) {
            status = "FAIL";
            throw ex;
        } finally {
            long dur = System.currentTimeMillis() - t0;

            // 3) VO를 완전히 채워서 비동기로 기록
            LogUserEventVO vo = new LogUserEventVO();
            vo.setUserId(userId);
            vo.setEventType(eventType);
            vo.setFeature(feature);
            vo.setChannel(channel);
            vo.setClientIp(clientIp);
            vo.setParamJson(paramJson);
            vo.setContextJson(null);
            vo.setResultRows(resultRows);
            vo.setDurationMs(dur);
            vo.setStatus(status);
            // vo.setRunAt(new Date()); // (트리거로 기본값 세팅 시 생략)

            logEventWriter.writeAsync(vo); // @Async + REQUIRES_NEW
        }
    }

    private String resolveUserId(Authentication auth) {
        if (auth == null || !auth.isAuthenticated() || auth instanceof AnonymousAuthenticationToken) return "ANON";
        String name = auth.getName();
        return (name == null || name.isBlank() || "anonymousUser".equalsIgnoreCase(name)) ? "ANON" : name;
    }

    private HttpServletRequest resolveRequest() {
        RequestAttributes ra = RequestContextHolder.getRequestAttributes();
        if (ra instanceof ServletRequestAttributes sra) return sra.getRequest();
        return null;
    }

    private LogEvent resolveAnnotation(ProceedingJoinPoint pjp, MethodSignature sig) {
        LogEvent ann = sig.getMethod().getAnnotation(LogEvent.class);
        if (ann != null) return ann;
        try {
            Method m = pjp.getTarget().getClass().getMethod(sig.getName(), sig.getParameterTypes());
            return m.getAnnotation(LogEvent.class);
        } catch (NoSuchMethodException e) {
            return null;
        }
    }

    private String resolveClientIp(HttpServletRequest req) {
        if (req == null) return null;
        String h = req.getHeader("X-Forwarded-For");
        return (h != null && !h.isBlank()) ? h.split(",")[0].trim() : req.getRemoteAddr();
    }

    private String resolveChannel(HttpServletRequest req) {
        if (req == null) return "SYSTEM";
        String ua = req.getHeader("User-Agent");
        return (ua != null && ua.toLowerCase().contains("mobi")) ? "MOBILE" : "WEB";
    }

    private String safeJson(Object o) {
        try { return objectMapper.writeValueAsString(o); }
        catch (Exception e) { return null; }
    }
}
