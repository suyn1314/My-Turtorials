from robot.api import ExecutionResult
from ScreenShotVisitor import ScreenShotVisitor
import datetime

class ReportListener:
    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self, *args):
        if not args:
            args=["INFO"]
        self.args = args
        self.keywords=[]
        self.ROBOT_LIBRARY_LISTENER = self

    def output_file(self, path):
        result = ExecutionResult(path)
        result.visit(ScreenShotVisitor(self.keywords, self.args[0]))
        result.save(path)

    def end_keyword(self, name, attributes):
        if attributes['status'] == 'FAIL':
            self.keywords.append({
                'Name': attributes['kwname'],
                'End time': attributes['endtime'],
            })