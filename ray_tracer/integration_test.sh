#!/bin/bash

# Ray Tracer Integration Test Script

set -e

echo "Ray Tracer Integration Test"
echo "=========================="

cd /home/runner/work/TheCamlBeforeTheStorm/TheCamlBeforeTheStorm/ray_tracer

echo "1. Clean build..."
dune clean

echo "2. Building project..."
dune build

echo "3. Running math tests..."
dune exec ./test/test_raytracer.exe

echo "4. Running ASCII rendering test..."
echo "   (This demonstrates the ray tracer is working correctly)"
ocaml -I _build/default/lib/.raytracer.objs/byte _build/default/lib/raytracer.cma test/test_ascii.ml

echo ""
echo "5. Checking executable exists..."
if [ -f "_build/default/bin/main.exe" ]; then
    echo "   ✓ GUI executable built successfully"
    file _build/default/bin/main.exe
else
    echo "   ✗ GUI executable not found"
    exit 1
fi

echo ""
echo "6. Project structure verification..."
echo "   Project files:"
find . -name "*.ml" -o -name "*.mli" -o -name "dune*" | sort

echo ""
echo "=========================="
echo "✅ All integration tests passed!"
echo ""
echo "To run the GUI application:"
echo "  cd ray_tracer"
echo "  dune exec ./bin/main.exe"
echo ""
echo "GUI Controls:"
echo "  WASD - Move light X/Y"
echo "  Q/E  - Move light Z" 
echo "  R    - Reset light"
echo "  SPACE - Re-render"
echo "  ESC  - Quit"