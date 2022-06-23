class PipeMeta(type):
    """元类"""
    def __or__(cls, obj):
        return cls(obj)


class Pipe(metaclass = PipeMeta):
    """管道组合宏
    e.g: Pipe | val | fn1 | fn2 | None
    等价于: fn2(fn1(val))
    """
    def __init__(self, obj):
        self._obj = obj

    def __or__(self, fn):
        if callable(fn):
            return type(self)(fn(self._obj))
        elif fn is None:
            return self._obj
        else:
            return NotImplemented

