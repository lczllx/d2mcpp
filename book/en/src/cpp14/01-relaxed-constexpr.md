<div align=right>

  🌎 [中文] | [English]
</div>

[中文]: ../../cpp14/01-relaxed-constexpr.html
[English]: ./01-relaxed-constexpr.html

# Relaxed constexpr

C++14 significantly relaxed the restrictions on `constexpr` functions — loops, branches, local variables, and multiple statements are now allowed, enabling far more algorithms to execute at compile time

| Book | Video | Code | X |
| --- | --- | --- | --- |
| [cppreference-constexpr](https://en.cppreference.com/w/cpp/language/constexpr) / [markdown](https://github.com/mcpp-community/d2mcpp/blob/main/book/en/src/cpp14/01-relaxed-constexpr.md) | [Video Explanation]() | [Exercise Code](https://github.com/mcpp-community/d2mcpp/blob/main/dslings/cpp14/01-relaxed-constexpr-0.cpp) |  |


**Why introduced?**

- In C++11, a `constexpr` function body was restricted to a single `return expr;` statement — any loop or branch had to be expressed via recursion and the ternary operator, making the code obscure
- Loops and branches are the most fundamental control flow in practical algorithms; excluding them from constexpr severely limited the scope of compile-time computation
- C++14 allows `for` / `while` / `if` / `switch` and local variables in constexpr functions, making it possible to move runtime algorithms to compile time without rewriting their style

**C++11 vs C++14 constexpr**

```cpp
// C++11: recursion + ternary operator
constexpr int factorial_11(int n) {
    return n <= 1 ? 1 : n * factorial_11(n - 1);
}

// C++14: plain loop
constexpr int factorial_14(int n) {
    int result = 1;
    for (int i = 1; i <= n; ++i) {
        result *= i;
    }
    return result;
}
```

## I. Basic Usage and Scenarios

### Loop Structures — for / while

> constexpr functions can use loops just like normal functions

```cpp
constexpr int sum_to(int n) {
    int total = 0;
    for (int i = 1; i <= n; ++i) {
        total += i;
    }
    return total;
}

static_assert(sum_to(5) == 15, "");
static_assert(sum_to(100) == 5050, "");
```

### Branch Structures — if / switch

```cpp
constexpr int abs_val(int x) {
    if (x < 0) {
        return -x;
    }
    return x;
}

static_assert(abs_val(-42) == 42, "");
static_assert(abs_val(0) == 0, "");

constexpr int day_count(int month) {
    switch (month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 4: case 6: case 9: case 11:
            return 30;
        case 2:
            return 28;
        default:
            return 0;
    }
}

static_assert(day_count(7) == 31, "");
```

### Local Variables and Multiple Statements

```cpp
constexpr double circle_area(double radius) {
    const double pi = 3.14159;
    double r2 = radius * radius;
    return pi * r2;
}

static_assert(circle_area(1.0) == 3.14159, "");
```

### Practical Compile-Time Algorithm — Loop-Based Fibonacci

> Replace recursion with a loop to compute fibonacci at compile time

```cpp
constexpr int fib(int n) {
    int a = 0, b = 1;
    for (int i = 0; i < n; ++i) {
        int tmp = a + b;
        a = b;
        b = tmp;
    }
    return a;
}

static_assert(fib(10) == 55, "");
static_assert(fib(0) == 0, "");
```

## II. Notes

### Operations Still Banned in C++14 constexpr

The following operations remain forbidden in C++14 constexpr functions:

- `goto` statements
- `try` / `catch` exception handling
- `static` or `thread_local` local variables
- inline assembly
- uninitialized local variables

### The "Dual Nature" of constexpr Functions

A constexpr function can execute at compile time or at runtime — depending on the call context:

```cpp
constexpr int fib(int n) {
    int a = 0, b = 1;
    for (int i = 0; i < n; ++i) {
        int tmp = a + b;
        a = b;
        b = tmp;
    }
    return a;
}

static_assert(fib(10) == 55, "");  // compile-time

int main() {
    int n = std::rand() % 20;
    return fib(n);                  // runtime — same code
}
```

### constexpr Is Not a Drop-In Replacement for inline

A constexpr specifier does not change the ODR linkage in C++14 (C++17 later made constexpr functions implicitly inline), nor does it mean every function that can be constexpr should be. If a function is almost always called at runtime, adding constexpr increases the interface constraint with little practical benefit

## III. Exercise Code

### Exercise Code Topics

- 0 - [constexpr Loops — Compile-Time Factorial and Power](https://github.com/mcpp-community/d2mcpp/blob/main/dslings/en/cpp14/01-relaxed-constexpr-0.cpp)
- 1 - [constexpr Branches and Local Variables — Compile-Time Conditionals and Fibonacci](https://github.com/mcpp-community/d2mcpp/blob/main/dslings/en/cpp14/01-relaxed-constexpr-1.cpp)

### Exercise Auto-Checker Command

```
d2x checker relaxed-constexpr
```

## IV. Other

- [Discussion Forum](https://forum.d2learn.org/category/20)
- [d2mcpp Tutorial Repository](https://github.com/mcpp-community/d2mcpp)
- [Tutorial Video List](https://space.bilibili.com/65858958/lists/5208246)
- [Tutorial Support Tool - xlings](https://github.com/openxlings/xlings)
