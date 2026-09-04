# Port matrix

`port-matrix` параллельно проверяет декартово произведение `hosts × ports` с
ограниченным числом workers и timeout на каждую пару. Это удобно для проверки
firewall, routing и service exposure с конкретной jump host или runner.

## Сборка и input

```bash
cd 1_linux/3_scripts_bash_python/go/port-matrix
go build -o port-matrix .

cat > targets.txt <<'EOF'
# NAME HOST
api 10.20.0.15
database db.internal.example
192.0.2.10
EOF
```

Строка содержит `HOST` либо `NAME HOST`. Для IPv6 допустим адрес с квадратными
скобками или без них. Имена используются только как labels в отчёте.

## Использование

```bash
# Обычные TCP connect probes
./port-matrix -f targets.txt -ports 22,5432,9100 \
  -concurrency 32 -timeout 2s

# На 443 дополнительно проверить TLS handshake, SNI и системную trust store
./port-matrix -f targets.txt -ports 22,443 -tls-ports 443 -json \
  > port-matrix.json

# Targets можно передать через stdin
printf 'api api.internal.example\n' | ./port-matrix -ports 80,443
```

Каждый `-tls-ports` должен присутствовать в `-ports`. TLS verification включена,
минимальная версия — TLS 1.2; флага отключения проверки нет. `-source` задаёт
label точки, откуда выполняется диагностика, например `bastion-eu-1`.

Код `0` означает успех всех probes, `1` — хотя бы один probe завершился ошибкой
или выполнение было прервано, `2` — некорректный input/output. Ошибка отдельной
пары включается в text/JSON report. Проверка подтверждает TCP/TLS-доступность,
но не готовность прикладного протокола; для HTTP используйте соседний
[`../endpoint-checker/`](../endpoint-checker/).
