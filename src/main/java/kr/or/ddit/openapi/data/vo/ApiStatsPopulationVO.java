package kr.or.ddit.openapi.data.vo;

import lombok.Data;

@Data
public class ApiStatsPopulationVO {
    private String admCode;
    private int statsYear;
    private long statsValue;
}