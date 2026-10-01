package serverest;

import com.intuit.karate.junit5.Karate;

class UsersTest {
    @Karate.Test
    Karate testUsers() {
        return Karate.run("users/users").relativeTo(getClass());
    }
}
