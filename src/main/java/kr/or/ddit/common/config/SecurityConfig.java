package kr.or.ddit.common.config;

import java.util.Arrays;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import jakarta.servlet.DispatcherType;
import kr.or.ddit.common.config.jwt.JWTAuthenticationFilter;
import kr.or.ddit.common.config.jwt.JWTAuthorizationFilter;
import kr.or.ddit.common.config.jwt.TokenProvider;
import kr.or.ddit.user.signin.mapper.UsersRefTokenMapper;
import kr.or.ddit.user.signin.service.impl.UserDetailServiceImpl;


@Configuration
@EnableWebSecurity
@EnableMethodSecurity // 메소드,클래스 레벨에서 보안할 수 있도록
public class SecurityConfig{

    private final UserDetailServiceImpl userDetailServiceImpl;
    private final TokenProvider tokenProvider;
    private final UsersRefTokenMapper usersRefTokenMapper;
    private final CustomLogoutSuccessHandler customLogoutSuccessHandler;
    private final CustomAuthenticationEntryPoint customAuthenticationEntryPoint; 

    
    public SecurityConfig(
        UserDetailServiceImpl userDetailServiceImpl,
        TokenProvider tokenProvider,
        UsersRefTokenMapper usersRefTokenMapper,
        CustomLogoutSuccessHandler customLogoutSuccessHandler,
        CustomAuthenticationEntryPoint customAuthenticationEntryPoint
    ) {
        this.userDetailServiceImpl  = userDetailServiceImpl;
        this.tokenProvider          = tokenProvider;
        this.usersRefTokenMapper     = usersRefTokenMapper;
        this.customLogoutSuccessHandler = customLogoutSuccessHandler;
        this.customAuthenticationEntryPoint = customAuthenticationEntryPoint;
    }
    

    @Bean
    public SecurityFilterChain securityFilterChain(
        HttpSecurity http,
        AuthenticationConfiguration authConfig
    ) throws Exception {
        AuthenticationManager authManager = authConfig.getAuthenticationManager();

        JWTAuthenticationFilter jwtAuthFilter =
            new JWTAuthenticationFilter(authManager, tokenProvider, usersRefTokenMapper);

        http
            .csrf(AbstractHttpConfigurer::disable)
            // ✨ CORS 설정을 Spring Security에 통합
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .sessionManagement(sm ->
                sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
              
            )
            .formLogin(AbstractHttpConfigurer::disable)
            .httpBasic(AbstractHttpConfigurer::disable)
            // ✨ 로그아웃 설정을 추가/수정
            .logout(logout -> logout
                .logoutUrl("/logout") // 로그아웃을 처리할 URL
                .logoutSuccessHandler(customLogoutSuccessHandler) // 우리가 만든 핸들러를 지정
                .invalidateHttpSession(true) // 세션 무효화
            )
            .authorizeHttpRequests(auth -> auth
                // 포워딩 허용
                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE).permitAll()
                .requestMatchers("/market/detailed/**").authenticated()
                .requestMatchers("/api/market/detailed/**").authenticated()
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .requestMatchers("/my/**").authenticated()
                .requestMatchers(
                        "/login", // 이제 컨트롤러가 처리할 수 있도록 /login도 허용 목록에 다시 추가
                        "/", 
                        "/css/**", 
                        "/js/**", 
                        "/images/**", 
                        "/fonts/**",
                        "/auth/**", 
                        "/oauth/**",
                        "/assets/**",
                        "/css_leejieun/**",
                        "/data/**",
                        "/favicons/**",
                        "/js_leejieun/**",
                        "/**" 
                        // 여기에 허용할 다른 URL들을 추가...
                    ).permitAll()
                .anyRequest().authenticated()
            )

            .exceptionHandling(exceptions -> exceptions
            	    // 기존: .authenticationEntryPoint(new LoginUrlAuthenticationEntryPoint("/login"))
            	    // 변경: 우리가 만든 CustomAuthenticationEntryPoint를 사용하도록 설정
            	    .authenticationEntryPoint(customAuthenticationEntryPoint)
            	    
            )
            .addFilterBefore(new JWTAuthorizationFilter(tokenProvider), UsernamePasswordAuthenticationFilter.class)
            // JWT 필터 가로채기
            .addFilterAt(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);


        return http.build();
    }

    @Bean // 매니저 작동 => 비밀번호 인증 ✨
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean //필터링 거치지 않는다 ignore
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring()
            .requestMatchers(
                "/css/**",
                "/js/**",
                "/images/**",
                "/fonts/**",
                "/assets/**",
                "/css_leejieun/**",
                "/data/**",
                "/favicons/**",
                "/js_leejieun/**"
            );
    }

    @Bean // 매니저 비밀번호 검증 도구
    public BCryptPasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }
    

    // CORS 설정을 Bean으로 등록 (유일한 설정 지점)
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList("http://localhost:3000", "http://localhost:5173","http://192.168.145.40:5173","http://192.168.145.4:5173","http://175.45.204.104:5173"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration); // 모든 경로에 대해 설정 적용
        return source;
    }
}