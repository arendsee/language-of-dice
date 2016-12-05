all:
	cd interpreter && ${MAKE} && mv lod .. && ${MAKE} clean

.PHONY: clean
clean:
	rm -f lod
	cd interpreter && ${MAKE} clean
