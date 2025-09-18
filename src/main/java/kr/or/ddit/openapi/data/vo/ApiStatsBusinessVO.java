package kr.or.ddit.openapi.data.vo;

import lombok.Data;

@Data
public class ApiStatsBusinessVO {
    private String admCode;
    private int statsYear;
    private String bizCodeId;
    private long statsValue;
}