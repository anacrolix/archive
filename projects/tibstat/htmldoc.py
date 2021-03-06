def tag(name, data=None, attrs=None, close_now=False):
    retval = '<{0}'.format(name)
    if attrs is not None:
        for k, v in attrs.iteritems():
            if v is not None:
                retval += ' {0}="{1}"'.format(k, v)
            else:
                retval += ' ' + k
    if data is None:
        if close_now:
            retval += '/>'
        else:
            retval += '>'
    else:
        retval += '>'
        retval += str(data)
        retval += '</{0}>'.format(name)
    return retval

class HtmlDocument(object):
    def __init__(self, write):
        self.write = write
        self.tagStack = []
        self.section = ''
    def indent(self):
        self.write(" " * (len(self.tagStack) - 1))
    #def write(self, data):
        #self.outputFile.write(str(data))
    def newline(self):
        self.write('\n')
        self.indent()
    def add_tag(self, name, data=None, attrs=None, inline=True, close_now=True):
        if not inline and len(self.tagStack) > 0:
            self.newline()
        self.write(tag(name, data, attrs, close_now=close_now))
    def open_tag(self, name, attrs=None, inline=True):
        self.add_tag(name, attrs=attrs, inline=inline, close_now=False)
        self.tagStack.append(name)
        #if alone:
        #    self.newline()
        return TagContext(self, name, inline)
    def close_tag(self, name, inline=True):
        assert name == self.tagStack.pop()
        if not inline:
            self.newline()
        self.write('</{0}>'.format(name))
    def writelns(self, lines):
        for l in lines:
            self.newline()
            self.write(l)
        #if alone:
        #    self.newline()

class TagContext(object):
    def __init__(self, htmldoc, tagname, inline):
        self.htmldoc = htmldoc
        self.tagname = tagname
        self.inline = inline
    def __enter__(self):
        pass
    def __exit__(self, *excinfo):
        self.htmldoc.close_tag(self.tagname, inline=self.inline)
