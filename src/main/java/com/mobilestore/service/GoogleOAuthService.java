package com.mobilestore.service;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.mobilestore.entity.User;
import com.mobilestore.dao.UserDAO;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class GoogleOAuthService {
    
    private static final String CLIENT_ID = "744565146565-ncqm19qq1eq9d0cq7l0q9k4ig88bnel5.apps.googleusercontent.com";
    private static final String GOOGLE_JWKS_URI = "https://www.googleapis.com/oauth2/v3/certs";
    
    private final UserDAO userDAO = new UserDAO();
    private final HttpClient httpClient = HttpClient.newHttpClient();
    private final Gson gson = new Gson();
    
    public User verifyAndGetUser(String idTokenString) {
        try {
            String userInfo = getGoogleUserInfo(idTokenString);
            
            if (userInfo != null) {
                JsonObject json = gson.fromJson(userInfo, JsonObject.class);
                
                String googleId = json.get("sub").getAsString();
                String email = json.has("email") ? json.get("email").getAsString() : null;
                String name = json.has("name") ? json.get("name").getAsString() : null;
                
                if (email == null) {
                    System.err.println("Google token không chứa email");
                    return null;
                }
                
                User user = userDAO.findByOauthId(googleId, "google");
                
                if (user == null) {
                    user = new User();
                    
                    String baseUsername = (name != null && !name.isEmpty()) ? name : email.split("@")[0];
                    String username = baseUsername;
                    int counter = 1;
                    
                    while (userDAO.findByUsername(username) != null) {
                        username = baseUsername + counter;
                        counter++;
                    }
                    
                    user.setUsername(username);
                    user.setPassword(null);
                    user.setOauthProvider("google");
                    user.setOauthId(googleId);
                    user.setEmail(email);
                    user.setRoleName("CUSTOMER");

                    user = userDAO.createWithOAuth(user);
                }
                
                return user;
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi verify Google token: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    private String getGoogleUserInfo(String idToken) {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://oauth2.googleapis.com/tokeninfo?id_token=" + idToken))
                .GET()
                .build();
            
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            
            if (response.statusCode() == 200) {
                return response.body();
            } else {
                System.err.println("Google API trả về lỗi: " + response.statusCode() + " - " + response.body());
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi gọi Google API: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
