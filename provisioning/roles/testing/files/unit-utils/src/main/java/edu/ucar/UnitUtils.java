package edu.ucar;

/**
 * Utility class for working with units.
 *
 * @author cwardgar
 * @since 2017-06-25
 */
public abstract class UnitUtils {
    /**
     * Converts {@code quantity} in yards to the equivalent value in meters.
     *
     * @param quantity  the value to convert.
     * @return          the equivalent value.
     */
    public static double convertYardsToMeters(double quantity) {
        return quantity * 0.9144;
    }

    // Private constructor to ensure non-instantiability.
    private UnitUtils() { }
}
