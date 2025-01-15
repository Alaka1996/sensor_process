name: CI

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Install dependencies
      run: |
        sudo apt update
        sudo apt install -y cppcheck cmake g++ gcc git

    - name: Run cppcheck
      run: |
        make cppcheck  # Run cppcheck for static analysis

    - name: Build application
      run: |
        make all  # Build the application

    - name: Install GoogleTest
      run: |
        # Remove existing googletest directory if it exists
        rm -rf googletest
        
        # Clone GoogleTest
        git clone --branch release-1.11.0 https://github.com/google/googletest.git googletest
        cd googletest
        mkdir build
        cd build
        cmake ..
        make
        sudo make install

    - name: Build tests
      run: |
        make test  # Build the tests

    - name: Run tests
      run: |
        ./bin/tests  # Run the tests

    - name: Upload artifacts
      if: ${{ failure() }}
      uses: actions/upload-artifact@v3
      with:
        name: logs
        path: bin/tests
