package kr.or.ddit.common.vo.code;

import lombok.Data;

/**
 * 법정동 코드 정보를 담기 위한 VO 클래스
 */
@Data
public class CodeDongVO {
	private String dongCode; // 법정동 코드 ID
	private String dongName; // 읍/면/동 명
	private int districtId; // 행정구 고유 ID

}
