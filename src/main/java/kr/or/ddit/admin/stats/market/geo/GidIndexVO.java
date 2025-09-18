package kr.or.ddit.admin.stats.market.geo;
import lombok.Data;

@Data
public class GidIndexVO {
    private String gid;        // DA_GRID.GRID_ID
    private String admCode;    // DA_GRID.ADM_CODE
    private Long   districtId; // DA_GRID.DISTRICT_ID
}