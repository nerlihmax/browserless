ARG VERSION=latest
ARG REPO=ghcr.io

# ============================================================
# Builder stage: compile TypeScript and generate assets.
# Firefox doesn't ship the function runner or the debugger payload,
# so neither build:function nor install:debugger run here.
# ============================================================
FROM $REPO/browserless/base:$VERSION AS builder
LABEL org.opencontainers.image.source=https://github.com/browserless/browserless

COPY src src/

RUN npm run build

# ============================================================
# Runtime stage: production-only deps + Firefox + built artifacts.
# ============================================================
FROM $REPO/browserless/base:$VERSION
LABEL org.opencontainers.image.source=https://github.com/browserless/browserless

RUN npm prune --omit=dev

USER blessuser
RUN ./node_modules/camoufox-js/dist/__main__.js fetch

USER root

# NOTE it's important to not use npx playwright-core here since it'll likely install
# a more recent version than we potentially have in our own package.json
RUN ./node_modules/playwright-core/cli.js install --with-deps firefox && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=builder $APP_DIR/build ./build
COPY --from=builder $APP_DIR/static ./static
COPY --from=builder $APP_DIR/extensions ./extensions

RUN chown -R blessuser:blessuser $APP_DIR

USER blessuser

CMD ["./scripts/start.sh"]
