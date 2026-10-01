package serverest.helpers;

import net.datafaker.Faker;
import java.util.HashMap;
import java.util.Map;

public class DataGenerator {
    private static final Faker faker = new Faker();

    public static Map<String, Object> getRandomUser() {
        Map<String, Object> user = new HashMap<>();
        user.put("nome", faker.name().fullName());
        user.put("email", faker.internet().emailAddress());
        user.put("password", faker.internet().password());
        user.put("administrador", "true");
        return user;
    }
}
