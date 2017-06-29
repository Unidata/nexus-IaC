package edu.ucar;

import ucar.units.*;

/**
 * Utility class for working with units.
 *
 * @author cwardgar
 * @since 2017-06-25
 */
public abstract class UnitUtils {
    /**
     * Converts {@code quantity} in {@code fromUnit} to the equivalent value in {@code toUnit}.
     *
     * @param quantity  the value to convert.
     * @param fromUnit  the unit of {@code quantity}.
     * @param toUnit    the unit to convert to.
     * @return          the equivalent value.
     * @throws UnitException  if either of the unit strings is invalid.
     */
    public static double convert(double quantity, String fromUnit, String toUnit) throws UnitException {
        Unit inputUnit = UnitFormatManager.instance().parse(fromUnit);
        Unit outputUnit = UnitFormatManager.instance().parse(toUnit);

        return inputUnit.convertTo(quantity, outputUnit);
    }

    // Private constructor to ensure non-instantiability.
    private UnitUtils() { }
}
