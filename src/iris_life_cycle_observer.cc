#include "iris_life_cycle_observer.h"

/// Empty implementation
namespace irisevent
{

  ILifeCycleObserver::ILifeCycleObserver(std::function<void()> cb)
  {
  }

  void ILifeCycleObserver::addApplicationObserver()
  {
  }

  void ILifeCycleObserver::removeApplicationObserver()
  {
  }
}