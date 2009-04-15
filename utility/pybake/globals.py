import classes

class ExplicitRules(dict):
    def __setitem__(self, key, value):
        if key in self:
            raise Exception("Target already registered", key)
        assert isinstance(value, classes.ExplicitRule)
        dict.__setitem__(self, key, value)

explicit_rules = ExplicitRules()
implicit_rules = []
