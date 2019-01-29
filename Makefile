CFLAGS += -g -Wall
OPENSSL_ROOT_DIR=/usr/local/ssl

all: spy ecc

spy: spy.c spy.S
	$(CC) -o $@ $^ $(CFLAGS)

ecc: ecc.c
	$(CC) -o $@ $< $(CFLAGS) -lcrypto -I$(OPENSSL_ROOT_DIR)/include -L$(OPENSSL_ROOT_DIR)/lib -Wl,-rpath=$(OPENSSL_ROOT_DIR)/lib

clean:
	rm -f spy ecc *~ *.pyc

deepclean: clean
	rm -f timings.bin data.bin data.sig secp384r1.pem

.PHONY: clean deepclean
