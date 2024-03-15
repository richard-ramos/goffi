package main

import (
	"fmt"
	"unsafe"
)

/*
#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>


typedef void (*SomeCallback) (int someParam);

// Include your own definitions and libraries before the next line
*/
import "C"

// More docs can be seen here https://pkg.go.dev/cmd/cgo , specially to deal with byte arrays

// Docs about myFunc1
//
//export myFunc1
func myFunc1(someStringParam *C.char, someIntParam C.int, someVoidParam unsafe.Pointer, someCallback C.SomeCallback) {
	// You can convert parameters into go data types like this:
	myInt := int(someIntParam)
	myString := C.GoString(someStringParam)

	fmt.Println("Hello World", myInt, myString)
}

//export myFunc2
func myFunc2() *C.char {
	// If you return a *C.char, you need to provide a function to free it
	return C.CString("Hello World")
}

//export freeString
func freeString(toFree *C.char) { // You could have used unsafe.Pointer, and then pass a (void *) from C
	C.free(unsafe.Pointer(toFree))
}

func main() {
	// Only required so the project compiles
}
