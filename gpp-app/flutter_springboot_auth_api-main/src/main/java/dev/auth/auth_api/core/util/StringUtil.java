package dev.auth.auth_api.core.util;

public class StringUtil {

    public static Boolean isNull(String string1) {
        return string1 == null;
    }

    public static Boolean isNotNull(String string1) {
        return !isNull(string1);
    }
}
