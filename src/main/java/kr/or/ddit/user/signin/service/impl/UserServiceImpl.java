package kr.or.ddit.user.signin.service.impl;

import kr.or.ddit.admin.users.vo.UsersHistoryVO;
import kr.or.ddit.common.vo.code.CodeAdmDongVO;
import kr.or.ddit.common.vo.code.CodeBizVO;
import kr.or.ddit.common.vo.code.CodeDistrictVO;
import kr.or.ddit.common.vo.user.UserMyBizVO;
import kr.or.ddit.common.vo.user.UserMyDistrictVO;
import kr.or.ddit.common.vo.user.UsersBizIdVO;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.notification.service.NotificationService;
import kr.or.ddit.notification.vo.UserNotifiedVO;
import kr.or.ddit.user.signin.mapper.UserSocialMapper;
import kr.or.ddit.user.signin.mapper.UsersMapper;
import kr.or.ddit.user.signin.service.UserService;
import kr.or.ddit.user.signin.vo.UserSocialVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UsersMapper usersMapper;
    private final UserSocialMapper userSocialMapper;

    private final PasswordEncoder passwordEncoder;
    private final NotificationService notificationService; //알림 서비스 추가 

    /**
     * 회원 가입을 처리합니다.
     *
     * @param user 가입할 회원 정보
     */
    @Override
    @Transactional
    public void signUpUser(UsersVO user) {
        usersMapper.insertUser(user);
        usersMapper.insertAuth(user.getUserId(), "ROLE_USER");

        if (user.getUserMyDistrictVOList() != null) {
            user.getUserMyDistrictVOList().stream()
                    .filter(d -> d != null && d.getAdmCode() != null && !d.getAdmCode().isBlank())
                    .forEach(d -> {
                        d.setUserId(user.getUserId());
                        usersMapper.insertMyDistrict(d);
                    });
        }

        if (user.getUserMyBizVOList() != null) {
            user.getUserMyBizVOList().stream()
                    .filter(b -> b != null && b.getBizCodeId() != null && !b.getBizCodeId().isBlank())
                    .forEach(b -> {
                        b.setUserId(user.getUserId());
                        usersMapper.insertMyBiz(b);
                    });
        }
    }

    /**
     * 사용자 아이디의 사용 가능 여부를 확인합니다.
     *
     * @param userId 확인할 사용자 아이디
     * @return 사용 가능하면 true, 아니면 false
     */
    @Override
    public boolean isUserIdAvailable(String userId) {
        int count = usersMapper.countByUserId(userId);
        log.info("count : " + count);
        return count == 0;
    }

    /**
     * 업종 대분류 목록을 조회합니다.
     *
     * @return 업종 대분류 리스트
     */
    @Override
    public List<CodeBizVO> getMainBizCategories() {
        return usersMapper.selectMainBizCategories();
    }

    /**
     * 지정된 대분류에 속한 중분류 목록을 조회합니다.
     *
     * @param parentCodeId 상위 대분류 코드
     * @return 업종 중분류 리스트
     */
    @Override
    public List<CodeBizVO> getSubBizCategories(String parentCodeId) {
        return usersMapper.selectSubBizCategories(parentCodeId);
    }

    /**
     * 전체 자치구 목록을 조회합니다.
     *
     * @return 자치구(VO) 리스트
     */
    @Override
    public List<CodeDistrictVO> getAllDistricts() {
        return usersMapper.selectAllDistricts();
    }

    /**
     * 지정된 자치구(districtId)에 속한 행정동 목록을 조회합니다.
     *
     * @param districtId 상위 자치구 ID
     * @return 행정동(VO) 리스트
     */
    @Override
    public List<CodeAdmDongVO> getDongsByDistrict(int districtId) {
        return usersMapper.selectDongsByDistrict(districtId);
    }


    /**
     * 사용자 아이디로 회원 정보를 조회합니다.
     *
     * @param userId 조회할 사용자 아이디
     * @return 조회된 회원 정보
     */
    @Override
    public UsersVO findByUserId(String userId) {
        return usersMapper.selectByUserId(userId);
    }

    /**
     * 사용자에게 권한을 부여합니다.
     *
     * @param userId 권한을 부여할 사용자 아이디
     * @param role   부여할 권한명
     */
    @Override
    public void addAuth(String userId, String role) {
        usersMapper.insertAuth(userId, role);
    }

    /**
     * 사용자 기본 정보를 업데이트합니다.
     * 비밀번호는 별도 로직으로 처리하는 것이 일반적입니다.
     *
     * @param user 업데이트할 사용자 정보 (UsersVO)
     * @return 업데이트 성공 시 1, 실패 시 0
     */
    @Override
    @Transactional
    public int updateUserInfo(UsersVO user) {
        log.info("updateUserInfo() - 사용자 정보 업데이트 요청 (ID: {})", user.getUserId());
        return usersMapper.updateUser(user);
    }

    //----------------- 마이페이지 선호정보 업데이트 관련 -------------------

    /**
     * [수정] 사용자의 관심 지역을 단일 항목으로 업데이트합니다.
     * @param userId 사용자 ID
     * @param district 단일 관심 지역 정보
     */
    @Override
    @Transactional
    public void updateMyDistrict(String userId, UserMyDistrictVO district) {
        // 1. 기존 관심 지역을 모두 삭제합니다.
        usersMapper.deleteMyDistricts(userId);
        
        // 2. 새로운 관심 지역 정보가 유효할 경우에만 추가합니다.
        //    (사용자가 '선택 안함'을 저장하는 경우를 대비)
        if (district != null && district.getAdmCode() != null && !district.getAdmCode().isEmpty()) {
            district.setUserId(userId);
            usersMapper.insertMyDistrict(district);
        }
    }

    /**
     * [수정] 사용자의 관심 업종을 단일 항목으로 업데이트합니다.
     * @param userId 사용자 ID
     * @param biz 단일 관심 업종 정보
     */
    @Override
    @Transactional
    public void updateMyBiz(String userId, UserMyBizVO biz) {
        // 1. 기존 관심 업종을 모두 삭제합니다.
        usersMapper.deleteMyBizs(userId);
        
        // 2. 새로운 관심 업종 정보가 유효할 경우에만 추가합니다.
        if (biz != null && biz.getBizCodeId() != null && !biz.getBizCodeId().isEmpty()) {
            biz.setUserId(userId);
            usersMapper.insertMyBiz(biz);
        }
    }

    // ================== ⭐⭐ 회원 상태 관리 관련 (관리자용) 구현 ⭐⭐ ==================

    /**
     * [Read] 관리자 페이지용 회원 목록을 조회합니다.
     *
     * @param paramMap 검색 및 페이징 조건
     * @return 조건에 맞는 UsersVO 리스트
     */
    @Override
    public List<UsersVO> getUsersList(Map<String, Object> paramMap) {
        log.info("getUsersList 호출: {}", paramMap);
        List<UsersVO> userList = usersMapper.selectUsersList(paramMap); // 이 줄 바로 다음!

        // --- 아래 코드를 복사해서 이 위치에 붙여넣기 해주세요 ---
        for (UsersVO user : userList) {
            log.debug("User ID: {}, Enabled Value in VO: '{}', Type: {}",
                    user.getUserId(), user.getEnabled(), user.getEnabled() != null ? user.getEnabled().getClass().getName() : "null");
        }
        // -----------------------------------------------------

        return userList;
    }

    /**
     * [Read] 특정 사용자의 상세 정보만 조회합니다.
     *
     * @param userId 조회할 사용자의 ID
     * @return UsersVO 객체 (상세 정보)
     */
    @Override
    public UsersVO getUserDetail(String userId) {
        log.info("getUserDetail 호출: {}", userId);
        return usersMapper.selectByUserId(userId);
    }

    /**
     * [Read] 특정 사용자의 상태 변경 이력만 조회합니다.
     *
     * @param userId 조회할 사용자의 ID
     * @return UsersHistoryVO 리스트
     */
    @Override
    public List<UsersHistoryVO> getUserHistoryList(String userId) {
        log.info("getUserHistoryList 호출: {}", userId);
        return usersMapper.selectUserHistory(userId);
    }

    /**
     * [Update] 관리자가 회원의 상태(활성/정지)를 변경합니다.
     * 트랜잭션 내에서 USERS 테이블 업데이트, USERS_HISTORY 삽입 또는 업데이트를 수행합니다.
     * 활성화(해제) 시에는 기존 정지 이력의 해제일(expiresAt)을 업데이트합니다.
     *
     * @param userId           상태를 변경할 사용자 ID
     * @param newEnabledStatus 새로운 ENABLED 상태 ('Y' 또는 'N')
     * @param reason           상태 변경 사유 (정지 시 필수, 활성화 시 null 가능)
     * @param changedBy        상태를 변경하는 관리자 ID
     * @param suspensionPeriod 정지 기간 (일 단위). 활성화 시 null 또는 0
     * @return 상태 변경 성공 시 true, 실패 시 false
     */
    @Override
    @Transactional // 트랜잭션 관리: 여러 DB 작업이 하나의 논리적 단위로 처리되도록 함
    public boolean updateUserStatus(String userId, String newEnabledStatus, String reason, String changedBy, Integer suspensionPeriod) {
        log.info("updateUserStatus 호출: userId={}, newStatus={}, reason={}, changedBy={}, suspensionPeriod={}",
                userId, newEnabledStatus, reason, changedBy, suspensionPeriod);

        UsersVO currentUser = usersMapper.selectByUserId(userId);
        if (currentUser == null) {
            log.warn("updateUserStatus: 사용자 ID를 찾을 수 없음: {}", userId);
            return false;
        }

        String preEnabledStatus = currentUser.getEnabled();

        // 현재 상태와 변경될 상태가 같으면 아무것도 할 필요 없음
        if (preEnabledStatus != null && preEnabledStatus.equals(newEnabledStatus)) {
            log.info("updateUserStatus: 현재 상태와 변경 요청 상태가 동일함 (userId: {}, status: {})", userId, newEnabledStatus);
            return true;
        }

        // 1. USERS 테이블 업데이트 (ENABLED 상태만 변경)
        Map<String, Object> updateParams = new HashMap<>();
        updateParams.put("userId", userId);
        updateParams.put("newEnabledStatus", newEnabledStatus);
        int userUpdateCount = usersMapper.updateUserEnabledStatus(updateParams);

        if (userUpdateCount == 0) {
            log.error("updateUserStatus: USERS 테이블 enabled 상태 업데이트 실패 for userId: {}", userId);
            // 런타임 예외를 발생시켜 @Transactional 어노테이션에 의해 롤백되도록 함
            throw new RuntimeException("사용자 상태 업데이트 실패");
        }

        // 2. USERS_HISTORY 테이블에 이력 기록 또는 업데이트
        if ("N".equals(newEnabledStatus)) { // '정지'로 변경될 때: 새로운 정지 이력 추가
            UsersHistoryVO history = new UsersHistoryVO();
            history.setUserId(userId);
            history.setPreEnabled(preEnabledStatus); // 정지 전 상태 (보통 'Y')
            history.setNewEnabled(newEnabledStatus); // 정지 후 상태 ('N')
            history.setReason(reason); // 정지 사유 (필수)
            history.setChangedBy(changedBy);
            history.setChangedAt(new Date()); // 정지된 시각

            // suspensionPeriod를 사용하여 expiresAt (해제일) 계산
            if (suspensionPeriod != null && suspensionPeriod > 0) {
                Calendar cal = Calendar.getInstance();
                cal.setTime(new Date()); // 현재 시간
                cal.add(Calendar.DATE, suspensionPeriod); // suspensionPeriod 일 더하기
                history.setExpiresAt(cal.getTime());
            } else {
                // suspensionPeriod가 없거나 0이면 무기한 정지 (null)
                history.setExpiresAt(null);
            }

            usersMapper.insertUserHistory(history); // 새로운 정지 이력 삽입
            log.info("updateUserStatus: userId={} 계정 정지 이력 추가됨 (pre: {}, new: {}, expiresAt: {}).",
                    userId, preEnabledStatus, newEnabledStatus, history.getExpiresAt());

            // --- [알림 생성 로직] ---
            UserNotifiedVO notification = new UserNotifiedVO();
            notification.setUserId(userId);
            notification.setEntityType("USERS_HISTORY");
            notification.setEntityId(String.valueOf(history.getHistoryId()));
            notification.setMessage("회원님의 계정이 '" + reason + "' 사유로 이용 정지되었습니다.");
            notificationService.createNotification(notification);
            // ------------------------

        } else if ("Y".equals(newEnabledStatus)) { // '활성화'로 변경될 때: 기존 정지 이력의 해제일 업데이트
            // 가장 최신 '미해제' 정지 이력을 찾습니다. (newEnabled = 'N' 이면서 expiresAt이 null인 이력)
            Optional<UsersHistoryVO> latestSuspensionOpt = usersMapper.findLatestActiveSuspensionByUserId(userId);

            if (latestSuspensionOpt.isPresent()) {
                UsersHistoryVO latestSuspension = latestSuspensionOpt.get();
                // 해당 정지 기록의 expiresAt (해제일)을 현재 시간으로 업데이트
                latestSuspension.setExpiresAt(new Date());
                latestSuspension.setChangedBy(changedBy); // 누가 해제했는지 기록 (선택 사항, 필요하다면)

                usersMapper.updateUserHistoryExpiresAt(latestSuspension);
                log.info("updateUserStatus: userId={} 계정 정지 이력 해제일 업데이트됨 (historyId: {}).", userId, latestSuspension.getHistoryId());
            } else {
                // 이전에 정지 이력이 없었거나, 이미 해제된 상태였다면
                log.warn("updateUserStatus: userId={} 계정 활성화 요청 시, 미해제 정지 이력이 없거나 이미 해제됨. 새로운 history 추가하지 않음.", userId);
                // 이 경우 USERS_HISTORY에 새로운 레코드를 삽입하지 않습니다.
            }
        }

        // 3. 계정 비활성화 시 JWT 토큰 무효화 (ENABLED 'Y' -> 'N'으로 변경되는 경우)
        if ("N".equals(newEnabledStatus) && "Y".equals(preEnabledStatus)) {
            int deletedTokens = usersMapper.deleteUserRefreshTokens(userId);
            log.info("updateUserStatus: userId={} 리프레시 토큰 {}개 삭제됨.", userId, deletedTokens);
        }

        return true;
    }

    // ================== ⭐⭐ 회원 탈퇴 (사용자 본인 요청) 구현 ⭐⭐ ==================

    /**
     * 비밀번호를 검증하고 회원을 탈퇴 처리합니다.
     * 이 메서드는 계정을 비활성화하고 탈퇴일시(WITHDRAWN_AT)를 기록합니다.
     *
     * @param userId          탈퇴할 회원 아이디
     * @param enteredPassword 사용자가 입력한 비밀번호
     * @param reason          탈퇴 사유
     * @param reasonDetail    탈퇴 상세 사유
     * @return 탈퇴 성공 시 true, 실패 시 false
     */
    @Override
    @Transactional
    public boolean withdrawUser(String userId, String enteredPassword, String reason, String reasonDetail) {
        log.info("사용자 본인 회원 탈퇴 시도: userId={}", userId);
        UsersVO userEntity = usersMapper.selectByUserId(userId);

        if (userEntity == null) {
            log.warn("withdrawUser: 사용자 ID를 찾을 수 없음: {}", userId);
            return false;
        }

        // 이미 탈퇴 상태인 경우
        // enabled가 'N'이고, withdrawnAt이 null이 아니면 이미 탈퇴 처리된 것으로 간주
        if ("N".equals(userEntity.getEnabled()) && userEntity.getWithdrawnAt() != null) {
            log.warn("withdrawUser: 이미 탈퇴 처리된 계정입니다: userId={}", userId);
            return false;
        }

        String storedHashedPassword = userEntity.getPassword();

        if (!passwordEncoder.matches(enteredPassword, storedHashedPassword)) {
            log.info("withdrawUser: 비밀번호 불일치 for userId: {}", userId);
            return false;
        }

        try {
            // `usersMapper.withdrawUser` 호출: USERS 테이블의 ENABLED='N'으로 변경하고 WITHDRAWN_AT에 현재 시각 기록
            int updateCount = usersMapper.withdrawUser(userId);

            if (updateCount > 0) {
                log.info("withdrawUser: 회원 계정 성공적으로 탈퇴 처리됨: userId={}", userId);

                // 사용자 본인 탈퇴 시에도 리프레시 토큰 무효화
                int deletedTokens = usersMapper.deleteUserRefreshTokens(userId);
                log.info("withdrawUser: userId={} 리프레시 토큰 {}개 삭제됨 (본인 탈퇴).", userId, deletedTokens);

                // ⭐ 본인 탈퇴 이력 USERS_HISTORY에 기록
                UsersHistoryVO history = new UsersHistoryVO();
                history.setUserId(userId);
                history.setPreEnabled(userEntity.getEnabled()); // 탈퇴 전 현재 사용자 상태
                history.setNewEnabled("N"); // 탈퇴 후 상태는 'N'

                String combinedReason = reason != null && !reason.isEmpty() ? reason : "사용자 본인 탈퇴";
                if (reasonDetail != null && !reasonDetail.isEmpty()) {
                    combinedReason += " (상세: " + reasonDetail + ")";
                }
                history.setReason(combinedReason);

                history.setChangedBy(userId); // 본인이 변경한 것으로 기록 (관리자가 아닌 사용자 본인 ID)
                history.setChangedAt(new Date()); // ⭐ 변경된 UsersHistoryVO에 맞춰 changedAt 필드 사용
                // history.setExpiresAt(null); // ⭐ UsersHistoryVO에서 expiresAt은 정지 만료일에만 사용하므로, 탈퇴 시에는 설정하지 않거나 null로 둠. 필드 없었으므로 이 줄은 제거합니다.

                usersMapper.insertUserHistory(history);
                log.info("withdrawUser: 사용자 본인 탈퇴 이력 기록됨 for userId: {}", userId);

                return true;
            } else {
                log.error("withdrawUser: 회원 탈퇴 처리 실패 (영향 받은 행 없음): userId={}", userId);
                return false;
            }
        } catch (Exception e) {
            log.error("withdrawUser: 회원 탈퇴 처리 중 예상치 못한 오류 발생: userId={}, error={}", userId, e.getMessage(), e);
            throw new RuntimeException("회원 탈퇴 처리 중 시스템 오류가 발생했습니다.", e);
        }
    }


    /**
     * 소셜 로그인 정보를 조회합니다.
     *
     * @param provider       소셜 서비스 제공자 (예: "google", "kakao")
     * @param providerUserId 소셜 서비스의 사용자 식별자
     * @return 조회된 소셜 정보
     */
    @Override
    public UserSocialVO findSocial(String provider, String providerUserId) {
        return userSocialMapper.selectByProviderAndProviderUserId(provider, providerUserId);
    }

    /**
     * 새로운 소셜 로그인 정보를 등록합니다.
     *
     * @param social 등록할 소셜 정보
     */
    @Override
    @Transactional
    public void insertSocial(UserSocialVO social) {
        userSocialMapper.insertSocial(social);
    }

    /**
     * 소셜 로그인 액세스 토큰을 갱신합니다.
     *
     * @param provider       소셜 서비스 제공자
     * @param providerUserId 소셜 서비스의 사용자 식별자
     * @param accessToken    갱신할 액세스 토큰
     */
    @Override
    public void updateSocialToken(String provider, String providerUserId, String accessToken) {
        userSocialMapper.updateAccessToken(provider, providerUserId, accessToken);
    }


    /**
     * 사업자 번호 정보를 등록합니다.
     *
     * @param bizVO 등록할 사업자 번호 정보
     * @return 등록된 행의 수
     */
    @Override
    public int registerBusinessNumber(UsersBizIdVO bizVO) {
        return usersMapper.insertBusinessNumber(bizVO);
    }

    @Override
    public int getUsersCount(Map<String, Object> paramMap) {
        return usersMapper.getUsersCount(paramMap);
    }

    // 사업자번호 변경, 등록
    @Override
    @Transactional
    public void insertOrUpdateBizInfo(UsersBizIdVO usersBizIdVO) {
        // 1. 쿼리 요구사항에 맞게 데이터 전처리
        //    사업자번호의 하이픈(-)을 제거하여 숫자만 남김
        String sanitizedBizNumber = usersBizIdVO.getBizNumber().replaceAll("[^0-9]", "");
        usersBizIdVO.setBizNumber(sanitizedBizNumber);

        //    개업일자 문자열의 하이픈(-)을 제거하여 YYYYMMDD 형식으로 만듬
        String sanitizedStartDate = usersBizIdVO.getStartDate().replaceAll("-", "");
        usersBizIdVO.setStartDate(sanitizedStartDate);

        // 2. 해당 사용자의 사업자 정보가 이미 있는지 확인
        UsersVO user = usersMapper.selectByUserId(usersBizIdVO.getUserId());

        if (user != null && user.getUsersBizIdVO() != null) {
            // 3. 정보가 이미 있으면 업데이트
            usersMapper.updateBizInfo(usersBizIdVO);
        } else {
            // 4. 정보가 없으면 새로 등록
            usersMapper.insertBusinessNumber(usersBizIdVO);
        }
    }

    @Override
    public Map<String, Object> getUserStatusSummary(Map<String, Object> params) {
        return usersMapper.selectUserStatusSummary(params);
    }

}