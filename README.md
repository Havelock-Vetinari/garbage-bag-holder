# Garbage Bag Holder making Cat litter box emtying easier

This [OpenSCAD](https://openscad.org) project creates a practical garbage bag holder designed to keep the bag open while emptying a cat litter box. The holder is printable on standard 3D printers with a build volume of at least 22cm x 22cm. It ensures the bag remains open and accessible, making the task of emptying the litter box cleaner and more convenient. The project is modular and can be adjusted to fit specific purposes or bag sizes. Additionally, combining several "middle" rings is possible for increased height and functionality.

## Overview

The garbage bag holder consists of a main frame supported by three circular rings, a hexagonal auxiliary base, and several support poles. The design is sturdy and modular, allowing for easy adjustments and customizations.

![holder render](docs/holder%20-%20all%20render.png?raw=true)

## Detailed Design Elements

### Support Rings

- **Bottom, Middle, Top Rings**:
    - Created using the `toroid` module, generating circular structures with specified diameters and thicknesses.
    - Positioned at the bottom, middle, and top sections of the frame.
    - Uses the `difference` function to allow poles to slot into the rings.

### Support Poles

- **Placement**: Four poles positioned at the cardinal points around the circumference.
- **Function**: Provides structural support and holds the rings in place.
- **Detail**: Each pole has upper and lower pins for secure attachment.

### Auxiliary Base and Poles

- **Base**: Created using the `round_hex_base` module, featuring a hexagonal grid for additional strength and a rim to contain any spillage.
    - **Bag Compatibility**: Ideal for use with smaller 25L bags.
    - Without the auxiliary base, the holder is compatible with larger 35L bags.
- **Auxiliary Poles**: Four auxiliary support poles provide additional height and stability, slotting into the base and equipped with pins for secure attachment.

## Usage and Functionality

- **Primary Function**: Keeps the garbage bag open and accessible, facilitating the process of emptying a cat litter box.
- **Convenience**: Ensures the bag remains open, minimizing mess and simplifying disposal.
- **Stability**: The design incorporates a stable base and multiple support points, ensuring the holder remains upright and the bag in place.

## Printable on 22cm x 22cm Printers

This design is suitable for printing on 3D printers with a build volume of at least 22cm x 22cm. The modularity allows for easy customization and adjustments for different bag sizes or purposes.

## Modular Adjustments

- **Combining Middle Rings**: You can combine several "middle" rings to increase the height of the holder, making it adaptable to various needs.
- **Bag Compatibility**: 
    - With the auxiliary base, the holder fits smaller 25L bags.
    - Without the base, it is compatible with larger 35L bags.

## Significiant modules

- **`toroid(diameter, ring_diameter)`**: Creates the support rings by revolving a circle along a defined path.
- **`pole(pole_d, pole_h, pin_diam, pin_len, lower_pin=true, upper_pin=true)`**: Generates the support poles with optional pins at both ends.
- **`round_hex_base(height, diameter, wall_thickness, rimm_height)`**: Constructs the hexagonal base with a rim for stability.

---

Happy printing and enjoy a cleaner, more convenient litter box maintenance experience!

**Note**: Ensure your 3D printer is properly calibrated for accurate dimensions and joint tolerances.

---
## Credits
Uses [Hex-grid](https://www.printables.com/model/86604-hexagonal-grid-generator-in-openscad) by [James Evans the mnmlMaker](https://www.printables.com/@JamesEvansthemnmlMak) 
