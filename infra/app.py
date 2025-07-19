#!/usr/bin/env python3
import aws_cdk as cdk
from langflow_stack import LangflowStack

app = cdk.App()
LangflowStack(app, "LangflowStack")
app.synth()

