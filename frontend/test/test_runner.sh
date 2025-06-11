#!/bin/bash

echo "Running Flutter Tests..."

echo "🧪 Running Unit Tests..."
flutter test test/unit/

echo "🎨 Running Widget Tests..."
flutter test test/widget/

echo "🔗 Running Integration Tests..."
flutter test integration_test/

echo "📊 Generating Test Coverage..."
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

echo "✅ All tests completed!"
echo "📈 Coverage report generated in coverage/html/index.html"
