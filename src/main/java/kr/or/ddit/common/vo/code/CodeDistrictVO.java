package kr.or.ddit.common.vo.code;

import lombok.Data;

/**
 * 행정구 코드 정보를 담기 위한 VO 클래스
 */
@Data
public class CodeDistrictVO {
	private long districtId; // 행정구 고유 ID
	private String districtAdmCode; // 행정구 행정동 코드 ID
	private String districtName; // 행정구명
	private String districtEdmCode; // 행정구 법정동 코드 ID

}
