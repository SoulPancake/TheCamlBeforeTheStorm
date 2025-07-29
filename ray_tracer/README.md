# OCaml Ray Tracer

A cross-platform GUI ray tracer implemented entirely in OCaml with interactive light source control.

## Features

- Real-time ray tracing of a 3D sphere
- Interactive GUI with light source movement controls
- Cross-platform compatibility (Windows/Mac/Linux)
- Comprehensive test suite for ray tracing mathematics
- Pure OCaml implementation using the Graphics module

## Controls

- **WASD** - Move light source in X/Y plane
- **Q/E** - Move light source along Z axis (forward/backward)
- **R** - Reset light source to default position
- **SPACE/ENTER** - Re-render scene
- **ESC** - Quit application

## Building and Running

### Prerequisites

- OCaml compiler (4.14.1+)
- Dune build system
- Graphics library for OCaml

### Ubuntu/Debian Installation

```bash
sudo apt update
sudo apt install -y ocaml ocaml-dune libgraphics-ocaml-dev
```

### Building

```bash
cd ray_tracer
dune build
```

### Running the GUI Application

```bash
dune exec ./bin/main.exe
```

### Running Tests

Run the comprehensive test suite:

```bash
dune exec ./test/test_raytracer.exe
```

Run ASCII rendering test:

```bash
ocaml -I _build/default/lib/.raytracer.objs/byte _build/default/lib/raytracer.cma test/test_ascii.ml
```

## Project Structure

```
ray_tracer/
├── dune-project          # Project configuration
├── lib/
│   ├── dune             # Library build configuration
│   └── raytracer.ml     # Core ray tracing math and algorithms
├── bin/
│   ├── dune             # Executable build configuration
│   └── main.ml          # GUI application
└── test/
    ├── dune             # Test build configuration
    ├── test_raytracer.ml # Comprehensive test suite
    └── test_ascii.ml    # ASCII rendering test
```

## Implementation Details

### Ray Tracing Algorithm

The ray tracer implements:

1. **3D Vector Mathematics** - Complete vector operations (add, subtract, scale, dot product, normalization)
2. **Ray-Sphere Intersection** - Analytical ray-sphere intersection using quadratic formula
3. **Surface Normals** - Calculation of surface normals for proper shading
4. **Diffuse Lighting** - Simple Lambertian diffuse lighting model

### Graphics Backend

Uses OCaml's Graphics module for cross-platform GUI:

- Pixel-by-pixel rendering
- Real-time user interaction
- Event handling for keyboard input
- Window management

### Testing

Comprehensive test coverage includes:

- Vector operation validation
- Ray-sphere intersection accuracy
- Surface normal calculations
- Shading computation
- ASCII rendering verification

## Technical Notes

- Renders at configurable resolution (default: 800x600)
- Uses perspective projection with 45° field of view
- Implements anti-aliasing through supersampling (can be enabled)
- Light intensity and shading calculations use floating-point precision
- Cross-platform compatibility through OCaml Graphics module

## Future Enhancements

Potential improvements:

- Multiple objects (planes, triangles, meshes)
- Reflections and refractions
- Anti-aliasing
- Texture mapping
- Multiple light sources
- Shadows
- Better performance optimization