package hkssprangers.server;

// Make sure we do not leaks secrets
#if browser
#error
#end

import hkssprangers.StaticResourceMacros.*;
import fastify.*;