import classes

class ExplicitRules(dict):
    def __setitem__(self, key, value):
        assert not key in self
        assert isinstance(value, classes.ExplicitRule)
        dict.__setitem__(self, key, value)

explicit_rules = ExplicitRules()
implicit_rules = []
