package kr.or.ddit.common.vo.data;

import java.util.Date;

import lombok.Data;

/**
 * 상점 정보 데이터를 담기 위한 VO 클래스
 */
@Data
public class DataStoreInfoVO {
    private int storeInfoId; // 상점 정보 ID
    private String dongCode; // 법정동 코드
    private String catCodeId; // 업종세세분류ID
    private Integer franchiseId; // 프랜차이즈 ID
    private String storeName; // 상점명
    private String address; // 주소
    private Object locationGeom; // 공간정보
    private Date openDate; // 개업일
    private Date closeDate; // 폐업일
}
