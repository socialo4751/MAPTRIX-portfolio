package kr.or.ddit.user.signin.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.admin.users.vo.UsersHistoryVO;
import kr.or.ddit.common.vo.code.CodeAdmDongVO;
import kr.or.ddit.common.vo.code.CodeBizVO;
import kr.or.ddit.common.vo.code.CodeDistrictVO;
import kr.or.ddit.common.vo.user.UserMyBizVO;
import kr.or.ddit.common.vo.user.UserMyDistrictVO;
import kr.or.ddit.common.vo.user.UsersBizIdVO;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.user.signin.vo.UserSocialVO;

/**
 * 사용자 관련 비즈니스 로직을 처리하는 서비스 인터페이스
 */
public interface UserService {

    //================== 회원가입 관련 ==================
    /**
     * 사용자가 입력한 정보로 회원가입을 처리합니다.
     * @param user 회원가입 정보
     */
    void signUpUser(UsersVO user);

    /**
     * 아이디 사용 가능 여부를 확인합니다.
     * @param userId 확인할 아이디
     * @return 사용 가능 시 true
     */
    boolean isUserIdAvailable(String userId);

    /**
     * 업종 대분류 목록을 조회합니다.
     * @return 업종 대분류 리스트
     */
    List<CodeBizVO> getMainBizCategories();

    /**
     * 선택된 대분류에 해당하는 중분류 목록을 조회합니다.
     * @param parentCodeId 부모(대분류) 업종 코드
     * @return 업종 중분류 리스트
     */
    List<CodeBizVO> getSubBizCategories(String parentCodeId);
    
    /**
     * 전체 자치구 목록을 조회합니다.
     * @return 자치구(VO) 리스트
     */
    List<CodeDistrictVO> getAllDistricts();

    /**
     * 지정된 자치구(districtId)에 속한 행정동 목록을 조회합니다.
     * @param districtId 상위 자치구 ID
     * @return 행정동(VO) 리스트
     */
    List<CodeAdmDongVO> getDongsByDistrict(int districtId);

    //================== 로그인 및 조회 관련 ==================
    /**
     * 아이디로 사용자 정보를 조회합니다. (권한 정보 포함)
     * @param userId 사용자 아이디
     * @return 사용자 정보
     */
    UsersVO findByUserId(String userId);

    /**
     * 사용자에게 권한을 부여합니다.
     * @param userId 사용자 아이디
     * @param role 부여할 권한
     */
    void addAuth(String userId, String role);

    /**
     * 사용자 기본 정보를 업데이트합니다.
     * 비밀번호는 별도 로직으로 처리하는 것이 일반적입니다.
     * @param user 업데이트할 사용자 정보 (UsersVO)
     * @return 업데이트 성공 시 1, 실패 시 0
     */
    int updateUserInfo(UsersVO user);
    
    //----------------- 마이페이지 선호정보 업데이트 관련 -------------------
    /**
     * [수정] 사용자의 관심 지역을 단일 항목으로 업데이트합니다.
     * @param userId 사용자 ID
     * @param district 단일 관심 지역 정보
     */
    void updateMyDistrict(String userId, UserMyDistrictVO district);
    
    /**
     * [수정] 사용자의 관심 업종을 단일 항목으로 업데이트합니다.
     * @param userId 사용자 ID
     * @param biz 단일 관심 업종 정보
     */
    void updateMyBiz(String userId, UserMyBizVO biz);

    //================== 회원 상태 관리 관련 (관리자용) ==================

    /**
     * [Read] 관리자 페이지용 회원 목록을 조회합니다.
     * 검색 조건 (searchKeyword, enabledStatus) 및 페이징 정보를 파라미터로 받습니다.
     * @param paramMap 검색 및 페이징 조건
     * @return 조건에 맞는 UsersVO 리스트
     */
    List<UsersVO> getUsersList(Map<String, Object> paramMap);

    /**
     * [Read] 특정 사용자의 상세 정보만 조회합니다. (이력은 별도 메서드로 조회)
     * @param userId 조회할 사용자의 ID
     * @return UsersVO 객체 (상세 정보)
     */
    UsersVO getUserDetail(String userId);

    /**
     * [Read] 특정 사용자의 상태 변경 이력만 조회합니다.
     * @param userId 조회할 사용자의 ID
     * @return UsersHistoryVO 리스트
     */
    List<UsersHistoryVO> getUserHistoryList(String userId);

    /**
     * [Update] 관리자가 회원의 상태(활성/정지)를 변경합니다.
     * 트랜잭션 내에서 USERS 테이블 업데이트, USERS_HISTORY 삽입 또는 업데이트를 수행합니다.
     * @param userId 상태를 변경할 사용자 ID
     * @param newEnabledStatus 새로운 ENABLED 상태 ('Y' 또는 'N')
     * @param reason 상태 변경 사유 (정지 시 필수, 활성화 시 null 가능)
     * @param changedBy 상태를 변경하는 관리자 ID
     * @param suspensionPeriod 정지 기간 (일 단위). 활성화 시 null 또는 0
     * @return 상태 변경 성공 시 true, 실패 시 false
     */
    boolean updateUserStatus(String userId, String newEnabledStatus, String reason, String changedBy, Integer suspensionPeriod);

    //================== 회원 탈퇴 (사용자 본인 요청) ==================
    /**
     * 사용자 본인 요청에 의한 회원 탈퇴를 처리합니다.
     * 비밀번호 검증 후 계정을 비활성화(ENABLED='N', WITHDRAWN_AT=SYSDATE)합니다.
     * @param userId 탈퇴하려는 사용자 ID
     * @param enteredPassword 사용자가 입력한 비밀번호 (평문)
     * @param reason 탈퇴 사유 (선택 사항)
     * @param reasonDetail 탈퇴 상세 사유 (선택 사항)
     * @return 비밀번호 일치 및 탈퇴 처리 성공 시 true, 비밀번호 불일치 또는 처리 실패 시 false
     */
    boolean withdrawUser(String userId, String enteredPassword, String reason, String reasonDetail);

    //================== 소셜 로그인 관련 ==================
    /**
     * 소셜 서비스 제공자와 고유 ID로 소셜 연동 정보를 조회합니다.
     * @param provider 소셜 서비스 제공자 (e.g., "NAVER", "KAKAO")
     * @param providerUserId 제공자별 사용자 고유 ID
     * @return 소셜 연동 정보
     */
    UserSocialVO findSocial(String provider, String providerUserId);

    /**
     * 신규 소셜 연동 정보를 등록합니다.
     * @param social 소셜 연동 정보
     */
    void insertSocial(UserSocialVO social);

    /**
     * 소셜 로그인 액세스 토큰을 갱신합니다.
     * @param provider 소셜 서비스 제공자
     * @param providerUserId 제공자별 사용자 고유 ID
     * @param accessToken 갱신할 액세스 토큰
     */
    void updateSocialToken(String provider, String providerUserId, String accessToken);

    /**
     * 사업자 번호를 등록한다.
     * @param bizVO (userId, bizNumber)
     * @return 성공 시 1, 실패 시 0
     */
    int registerBusinessNumber(UsersBizIdVO bizVO);

    // 사업자번호 변경
	void insertOrUpdateBizInfo(UsersBizIdVO usersBizIdVO);
	
    // 회원 목록 전체 개수 조회 (검색 조건 포함)
    int getUsersCount(Map<String, Object> paramMap);

    Map<String, Object> getUserStatusSummary(Map<String, Object> params);

}