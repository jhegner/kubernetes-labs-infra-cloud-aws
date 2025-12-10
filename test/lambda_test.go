package test

import (
	"testing"
	"github.com/stretchr/testify/mock"
)

type MockLambda struct {
	mock.Mock
}

func (m *MockLambda) FunctionName() string {
	args := m.Called()
	return args.String(0)
}

func TestLambdaFunction(t *testing.T) {
	mockLambda := new(MockLambda)
	mockLambda.On("FunctionName").Return("TestFunction")

	result := mockLambda.FunctionName()
	if result != "TestFunction" {
		t.Errorf("Expected TestFunction, got %s", result)
	}

	mockLambda.AssertExpectations(t)
}