FROM armhf/alpine

RUN apk add --update curl && mkdir -p /etc/cfssl/bin && mkdir -p /etc/cfssl/certs
RUN curl https://pkg.cfssl.org/R1.2/cfssl_linux-arm -o /etc/cfssl/bin/cfssl && curl https://pkg.cfssl.org/R1.2/cfssljson_linux-arm -o /etc/cfssl/bin/cfssljson
RUN chmod +x /etc/cfssl/bin/cfssl*

ENV CFSSL /etc/cfssl
ENV PATH $PATH:$CFSSL/bin
ENV CERT $CFSSL/certs

MAINTAINER jveltri73@gmail.com

ADD ssl /etc/cfssl/certs

WORKDIR  /etc/cfssl

EXPOSE 8888

ENTRYPOINT ["cfssl"]
CMD ["serve", "-address=0.0.0.0", "-port=8888", "-ca-key=$CERT/veltri_int_ca-key.pem", "-ca=$CERT/veltri_int_ca.pem", "-config=$CERT/intca_profiles.json", "-responder=$CERT/veltri-ocsp.pem", "-responder-key=$CERT/veltri-ocsp-key.pem"]