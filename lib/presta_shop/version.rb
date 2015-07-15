module PrestaShop
    MAJOR = 0
    MINOR = 1
    TINY  = 4
    ITERATION = 3

    VERSION = [MAJOR, MINOR, TINY, ITERATION].join('.')

    def self.version
        VERSION
    end
end
