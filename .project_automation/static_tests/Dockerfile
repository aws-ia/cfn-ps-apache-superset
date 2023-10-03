FROM public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:4.0
RUN git clone https://github.com/aws-quickstart/qs-cfn-lint-rules.git /tmp/qs-cfn-lint-rules
RUN cd /tmp/qs-cfn-lint-rules && git checkout 8268db9df3407ccf5383def635bc22e0f99d6b39 && pip install .
#RUN cfn-lint -u