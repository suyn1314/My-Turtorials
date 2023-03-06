from robot.api import ResultVisitor
from robot.model.message import Message

class ScreenShotVisitor(ResultVisitor):
    def __init__(self, keywords, level="INFO"):
        self.keywords = keywords
        self.level = level

    def end_keyword(self, kw): 
        for keyword in self.keywords:
            if keyword.get('End time') == kw.endtime and keyword.get('Name') == kw.kwname:
                kw.messages.create('<img src='+'"./remote_fail.png">', html=True , level=self.level)