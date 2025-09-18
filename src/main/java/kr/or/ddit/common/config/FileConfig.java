package kr.or.ddit.common.config; // 패키지를 config로 옮기는 것을 추천합니다.

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class FileConfig implements WebMvcConfigurer {

    // application.properties에 정의된 file.upload-dir 값을 주입받습니다.
    @Value("${file.upload-dir}")
    private String uploadDir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // /upload/** URL 요청이 오면,
        // 주입받은 uploadDir 경로에서 파일을 찾아 제공합니다.
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:///" + uploadDir);
    }
}