package kr.or.ddit.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.web.servlet.config.annotation.ContentNegotiationConfigurer;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import kr.or.ddit.openapi.auth.ApiKeyAuthInterceptor;
import kr.or.ddit.user.signup.step.SignUpStepInterceptor;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    // 파일 업로드 경로 주입을 위한 필드 추가
    @Value("${file.upload-dir}")
    private String uploadDir;

    private final SignUpStepInterceptor signUpStepInterceptor;
    
    private final ApiKeyAuthInterceptor apiKeyAuthInterceptor;

    
    public WebMvcConfig(SignUpStepInterceptor signUpStepInterceptor, ApiKeyAuthInterceptor apiKeyAuthInterceptor) {
        this.signUpStepInterceptor = signUpStepInterceptor;
        this.apiKeyAuthInterceptor = apiKeyAuthInterceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(signUpStepInterceptor)
                // ▼▼▼▼▼ 수정 ▼▼▼▼▼
                .addPathPatterns("/**") // 모든 경로를 감시 대상으로 변경
                .excludePathPatterns(
                        "/css/**", "/js/**", "/media/**", // 정적 리소스는 항상 제외
                        "/error",
                        "/sign-up/categories/**",  // AJAX 호출 제외
                        "/sign-up/checkId",        // AJAX 호출 제외
                        "/ws/**" 				   // 웹소캣 호출 제외 	
                );
        // ▲▲▲▲▲ 수정 ▲▲▲▲▲
        registry.addInterceptor(apiKeyAuthInterceptor)
        // 이 인터셉터는 /api/v1/ 로 시작하는 모든 경로에만 적용됩니다.
        .addPathPatterns("/api/v1/**");
    }

    /**
     * 리소스 핸들러를 설정합니다.
     * FileService에서 생성한 '/media/**' 형태의 가상 URL 경로 요청이 오면,
     * 실제 물리적 파일 저장 경로(uploadDir)에 매핑하여 파일을 웹에 노출시킵니다.
     * 실제 파일 경로는 application.properties에서 설정 합니다.
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 예: URL 요청 '/media/2025/07/24/image.jpg' -> 실제 파일 'C:/uploads/2025/07/24/image.jpg'
        registry.addResourceHandler("/media/**")
                .addResourceLocations("file:" + uploadDir + "/");
    }

    /*
     * securityConfig.java 에서 통합
     *
     * @Override public void addCorsMappings(CorsRegistry registry) {
     * registry.addMapping("/**") .allowedOrigins("http://localhost:5173",
     * "http://192.168.145.40:5173") // ✨ IP 주소 추가 .allowedMethods("GET", "POST",
     * "PUT", "DELETE", "OPTIONS") .allowedHeaders("*") .allowCredentials(true)
     * .maxAge(3600); }
     */
    @Override
    public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
        configurer.mediaType("geojson", MediaType.APPLICATION_JSON);
    }
}