BEGIN;
SELECT plan(4);

SELECT crypto_generichash_keygen() generickey \gset

SELECT is(crypto_generichash('bob is your uncle'),
          '\x6c80c5f772572423c3910a9561710313e4b6e74abc0d65f577a8ac1583673657',
          'crypto_generichash');

SELECT lives_ok(format($$select crypto_generichash('bob is your uncle', %L::bytea)$$, :'generickey'),
          'crypto_generichash with key');

SELECT crypto_shorthash_keygen() shortkey \gset

SELECT lives_ok(format($$select crypto_shorthash('bob is your uncle', %L::bytea)$$, :'shortkey'), 'crypto_shorthash');

SELECT throws_ok($$select crypto_shorthash('bob is your uncle', 's'::bytea)$$,
       '22000', 'pgsodium_crypto_shorthash: invalid key', 'crypto_shorthash invalid key');

SELECT * FROM finish();
ROLLBACK;

\if :serverkeys
BEGIN;
SELECT plan(2);

SELECT lives_ok(format($$select crypto_shorthash('bob is your uncle', 42)$$), 'crypto_shorthash_by_id');
SELECT lives_ok(format($$select crypto_shorthash('bob is your uncle', 42, '12345678')$$), 'crypto_shorthash_by_id_context');

SELECT * FROM finish();
ROLLBACK;

\endif
