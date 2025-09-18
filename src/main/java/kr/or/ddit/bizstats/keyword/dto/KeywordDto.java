package kr.or.ddit.bizstats.keyword.dto;

import java.util.Map;

public class KeywordDto {
    private String name;
    private long value;
    private Map<String, String> custom;

    // Constructors, Getters, and Setters
    public KeywordDto(String name, long value, Map<String, String> custom) {
        this.name = name;
        this.value = value;
        this.custom = custom;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public long getValue() { return value; }
    public void setValue(long value) { this.value = value; }
    public Map<String, String> getCustom() { return custom; }
    public void setCustom(Map<String, String> custom) { this.custom = custom; }
}