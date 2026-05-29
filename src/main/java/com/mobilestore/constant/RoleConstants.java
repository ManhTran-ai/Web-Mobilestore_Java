package com.mobilestore.constant;

public enum RoleConstants {
    ADMIN("ADMIN", "Administrator"),
    INVENTORY_MANAGER("INVENTORY_MANAGER", "INVENTORY_MANAGER"),
    CUSTOMER("CUSTOMER", "Customer");

    private final String roleName;
    private final String description;

    RoleConstants(String roleName, String description) {
        this.roleName = roleName;
        this.description = description;
    }

    public String getRoleName() {
        return roleName;
    }

    public String getDescription() {
        return description;
    }

    public static RoleConstants fromRoleName(String roleName) {
        for (RoleConstants role : values()) {
            if (role.roleName.equalsIgnoreCase(roleName)) {
                return role;
            }
        }
        return CUSTOMER;
    }
}