package kr.or.ddit.user.signin.mapper;

import java.util.List;
import java.util.Map;
import java.util.Optional; // Optional 클래스 임포트

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param; // @Param 어노테이션을 사용할 경우 import 필요

import kr.or.ddit.admin.users.vo.UsersHistoryVO;
import kr.or.ddit.common.vo.code.CodeAdmDongVO;
import kr.or.ddit.common.vo.code.CodeBizVO;
import kr.or.ddit.common.vo.code.CodeDistrictVO;
import kr.or.ddit.common.vo.user.UserMyBizVO;
import kr.or.ddit.common.vo.user.UserMyDistrictVO;
import kr.or.ddit.common.vo.user.UsersBizIdVO;
import kr.or.ddit.common.vo.user.UsersVO;

@Mapper
public interface UsersMapper {

    /**
     * 사용자 아이디로 회원 정보를 조회합니다.
     * @param userId 조회할 사용자 아이디
     * @return 조회된 회원 정보 (UsersVO)
     */
    UsersVO selectByUserId(String userId);

    /**
     * 사용자 아이디의 개수를 조회하여 중복 여부를 확인합니다.
     * @param userId 확인할 사용자 아이디
     * @return 해당 아이디의 개수
     */
    int countByUserId(String userId);

    /**
     * 새로운 회원 정보를 등록합니다.
     * @param user 등록할 회원 정보
     */
    void insertUser(UsersVO user);

    /**
     * 기존 회원의 정보를 수정합니다.
     * @param user 수정할 회원 정보
     * @return 수정된 행의 수
     */
    int updateUser(UsersVO user);

    /**
     * [Read] 회원 목록을 검색 조건과 함께 조회합니다.
     * @param paramMap 검색 조건 (searchKeyword, enabledStatus 등)
     * @return UsersVO 리스트
     */
    List<UsersVO> selectUsersList(Map<String, Object> paramMap);

    /**
     * [Read] 특정 사용자의 상태 변경 이력을 조회합니다.
     * 이 메서드의 SQL 쿼리는 '정지' 이력만 가져오도록 수정되어야 합니다.
     * @param userId 조회할 사용자의 ID
     * @return UsersHistoryVO 리스트 (정지 이력만)
     */
    List<UsersHistoryVO> selectUserHistory(String userId); // -> XML 쿼리 수정 필요

    /**
     * [Update] USERS 테이블의 ENABLED 상태만 업데이트합니다.
     * WITHDRAWN_AT은 이 메서드에서 변경하지 않습니다.
     * @param paramMap 업데이트할 정보 (userId, newEnabledStatus)
     * @return 업데이트된 행의 수
     */
    int updateUserEnabledStatus(Map<String, Object> paramMap);

    /**
     * [Update] USERS_HISTORY 테이블에 사용자 상태 변경 이력을 삽입합니다.
     * (주로 '정지' 이력 삽입 시 사용)
     * @param historyVO 삽입할 이력 정보
     * @return 삽입된 행의 수
     */
    int insertUserHistory(UsersHistoryVO historyVO);

    /**
     * [Update] 특정 사용자의 모든 리프레시 토큰을 삭제합니다.
     * @param userId 토큰을 삭제할 사용자의 ID
     * @return 삭제된 행의 수
     */
    int deleteUserRefreshTokens(String userId);

    /**
     * 회원을 탈퇴 처리합니다. (ENABLED='N'으로 변경 및 WITHDRAWN_AT 기록)
     * @param userId 탈퇴할 회원 아이디
     * @return 수정된 행의 수
     */
    int withdrawUser(String userId);

    /**
     * 사용자에게 권한을 부여합니다.
     * @param userId 권한을 부여할 사용자 아이디
     * @param role 부여할 권한명
     */
    void insertAuth(@Param("userId") String userId, @Param("role") String role);

    /**
     * 사용자의 관심 지역을 등록합니다.
     * @param userMyDistrict 등록할 관심 지역 정보
     */
    void insertMyDistrict(UserMyDistrictVO userMyDistrict);

    /**
     * 사용자의 관심 업종을 등록합니다.
     * @param userMyBiz 등록할 관심 업종 정보
     */
    void insertMyBiz(UserMyBizVO userMyBiz);

    // ================== [추가] 마이페이지 선호정보 삭제 관련 ==================
    /**
     * 사용자의 모든 관심 지역을 삭제합니다.
     * @param userId 삭제할 사용자의 ID
     * @return 삭제된 행의 수
     */
    int deleteMyDistricts(String userId);

    /**
     * 사용자의 모든 관심 업종을 삭제합니다.
     * @param userId 삭제할 사용자의 ID
     * @return 삭제된 행의 수
     */
    int deleteMyBizs(String userId);
    // =================================================================

    /**
     * 사용자의 사업자 정보를 등록합니다.
     * @param usersBizId 등록할 사업자 정보
     */
    void insertBizId(UsersBizIdVO usersBizId);

    /**
     * 업종 대분류 목록을 조회합니다.
     * @return 업종 대분류 리스트
     */
    List<CodeBizVO> selectMainBizCategories();

    /**
     * 지정된 대분류에 속한 중분류 목록을 조회합니다.
     * @param parentCodeId 상위 대분류 코드
     * @return 업종 중분류 리스트
     */
    List<CodeBizVO> selectSubBizCategories(String parentCodeId);

    // ================== [신규 추가] 자치구/행정동 조회 관련 ==================
    /**
     * 전체 자치구 목록을 조회합니다. (첫 번째 Select 박스용)
     * @return 자치구(VO) 리스트
     */
    List<CodeDistrictVO> selectAllDistricts();

    /**

     * 지정된 자치구(districtId)에 속한 행정동 목록을 조회합니다. (두 번째 Select 박스용)
     * @param districtId 상위 자치구 ID
     * @return 행정동(VO) 리스트
     */
    List<CodeAdmDongVO> selectDongsByDistrict(int districtId);
    // =================================================================

    /**
     * 사업자 번호 정보를 등록합니다. (UsersBizIdVO를 통한 등록)
     * @param bizVO 등록할 사업자 번호 정보
     * @return 등록된 행의 수
     */
    int insertBusinessNumber(UsersBizIdVO bizVO);

    // 사업자번호 변경
 	void updateBizInfo(UsersBizIdVO usersBizIdVO);

    // 새롭게 추가할 메서드들

    /**
     * [Read] 특정 사용자의 가장 최근 '미해제' 정지 이력을 조회합니다.
     * 미해제 정지 이력은 'NEW_ENABLED'가 'N'이고 'EXPIRES_AT'이 NULL인 경우를 의미합니다.
     * 이 메서드는 활성화 시 기존 정지 이력의 해제일(expiresAt)을 업데이트하기 위해 사용됩니다.
     * @param userId 조회할 사용자 ID
     * @return 가장 최근의 미해제 정지 이력 (Optional<UsersHistoryVO>), 없으면 Optional.empty()
     */
    Optional<UsersHistoryVO> findLatestActiveSuspensionByUserId(@Param("userId") String userId);

    /**
     * [Update] USERS_HISTORY 테이블의 특정 이력 레코드에 해제일(expiresAt)을 업데이트합니다.
     * 이 메서드는 '정지'된 회원을 '활성화'할 때, 해당 정지 기록의 '해제일'을 기록하는 데 사용됩니다.
     * @param historyVO 업데이트할 이력 정보 (historyId, expiresAt, changedBy 필드 사용)
     * @return 업데이트된 행의 수
     */
    int updateUserHistoryExpiresAt(UsersHistoryVO historyVO);

    int getUsersCount(Map<String, Object> paramMap);

    Map<String, Object> selectUserStatusSummary(Map<String, Object> params);
}