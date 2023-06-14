package kr.spring.entity;

import com.fasterxml.jackson.annotation.JsonProperty;

public class FlaskResponse {
	@JsonProperty("objects")
    private String[] objects;

    @JsonProperty("confidence")
    private double[] confidence;
}
