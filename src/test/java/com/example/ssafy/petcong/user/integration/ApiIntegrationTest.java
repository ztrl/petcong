package com.example.ssafy.petcong.user.integration;

import static org.assertj.core.api.Assertions.assertThat;

import com.example.ssafy.petcong.user.model.enums.Gender;
import com.example.ssafy.petcong.user.model.enums.Preference;
import com.example.ssafy.petcong.user.model.enums.Status;
import com.example.ssafy.petcong.user.model.record.UserRecord;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.transaction.Transactional;

import lombok.extern.slf4j.Slf4j;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import java.io.*;
import java.time.LocalDate;
import java.util.stream.Stream;

@Slf4j
@SpringBootTest
@AutoConfigureMockMvc
public class ApiIntegrationTest {
    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private MockMvc mockMvc;

    static Stream<Arguments> provideDummySignUpUser() {
        UserRecord userRecord = new UserRecord(
                1,
                1,
                false,
                "nickname",
                "smy@petcong.com",
                "Korea",
                "nope",
                "1",
                LocalDate.of(1997, 1, 29),
                Gender.MALE,
                Status.ACTIVE,
                Preference.FEMALE);
        return Stream.of(Arguments.of(userRecord));
    }

    @ParameterizedTest
    @MethodSource("provideDummySignUpUser")
    @Transactional
    @DisplayName("SignUp Test")
    @Disabled
    void testSignUp(UserRecord userRecord) throws Exception {
        String userRecordJson = objectMapper.writeValueAsString(userRecord);

        var request = MockMvcRequestBuilders
                .post("/users/signup")
                .header("tester", "A603")
                .content(userRecordJson)
                .contentType(MediaType.APPLICATION_JSON);

        MvcResult mvcResult = mockMvc
                .perform(request)
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andReturn();

        String response = mvcResult.getResponse().getContentAsString();

        assertThat(response).isNotNull();

        log.info(response);
    }

    @Test
    @DisplayName("Signin Test")
    @Transactional
    @Disabled
    void testSignin() throws Exception {
        var request = MockMvcRequestBuilders
                .post("/users/signin")
                .header("tester", "A603")
                .content("1")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED);

        MvcResult mvcResult = mockMvc
                .perform(request)
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andReturn();

        String response = mvcResult.getResponse().getContentAsString();

        assertThat(response).isNotNull();

        log.info(response);
    }

    @Test
    @DisplayName("PostProfileImage Test")
    @Disabled
    void testpostProfileImage() throws Exception {
        FileInputStream fileInputStream = new FileInputStream("C:\\Users\\SSAFY\\Downloads\\anya.jpg");
        byte[] bytes = fileInputStream.readAllBytes();
        MockMultipartFile multipartFile = new MockMultipartFile(
                "file",
                "img_anya",
                MediaType.MULTIPART_FORM_DATA_VALUE,
                bytes);

        var request = MockMvcRequestBuilders
                .multipart(HttpMethod.POST, "/users/picture")
                .file(multipartFile)
                .header("tester", "A603")
                .content("1")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED);

        MvcResult mvcResult = mockMvc
                .perform(request)
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
                .andReturn();

        String response = mvcResult.getResponse().getContentAsString();

        assertThat(response).isNotNull();

        log.info(response);
    }

}
