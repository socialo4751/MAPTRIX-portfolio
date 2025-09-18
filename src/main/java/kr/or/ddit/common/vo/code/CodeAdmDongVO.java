package kr.or.ddit.common.vo.code;

import lombok.Data;

/**
 * 행정동 코드 정보를 담기 위한 VO 클래스
 */
@Data
public class CodeAdmDongVO {
	private String admCode; // 행정동 코드 ID
	private String admName; // 행정동 명
	private int districtId; // 행정구 고유 ID
	private String dongCode;
}
