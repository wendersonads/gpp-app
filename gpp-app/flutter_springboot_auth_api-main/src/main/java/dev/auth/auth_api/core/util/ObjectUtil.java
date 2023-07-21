package dev.auth.auth_api.core.util;

public class ObjectUtil {

    public static Boolean isNull(Object object1) {
        return object1 == null;
    }

    public static Boolean isNotNull(Object object1) {
        return !isNull(object1);
    }
}
