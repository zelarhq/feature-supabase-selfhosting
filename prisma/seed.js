// prisma/seed.js
const { PrismaClient } = require('@prisma/client')
const fs = require('fs')
const path = require('path')
const { parse } = require('csv-parse/sync')

const prisma = new PrismaClient()

async function main() {
  try {
    // If you have SQL file
    // if (fs.existsSync(path.join(__dirname, './seed.sql'))) {
    //   const sqlFile = fs.readFileSync(path.join(__dirname, './seed.sql'), 'utf8')
    //   await prisma.$executeRawUnsafe(sqlFile)
    //   console.log('SQL seed completed!')
    // }

    // If you have CSV file
    if (fs.existsSync(path.join(__dirname, './marketplace_rows.csv'))) {
      const csvFile = fs.readFileSync(path.join(__dirname, './marketplace_rows.csv'), 'utf8')
      const records = parse(csvFile, {
        columns: true,
        skip_empty_lines: true
      })

      console.log(`Found ${records.length} records to insert`)

      for (const record of records) {
        // Convert string JSON fields to objects
        const values = JSON.parse(record.values || '{}')
        const label_check = JSON.parse(record.label_check || '{}')
        const optional_values = JSON.parse(record.optional_values || '{}')
        const credential_fields = JSON.parse(record.credential_fields || '{}')

        await prisma.marketplace.create({
          data: {
            uid: record.uid,
            values_reference: record.values_reference,
            helm_repo_add: record.helm_repo_add,
            display_name: record.display_name,
            values: values,
            id: record.id,
            category: record.category,
            default_enable: record.default_enable === 'true',
            show_in_marketplace: record.show_in_marketplace === 'true',
            icon: record.icon,
            description: record.description,
            know_more: record.know_more,
            namespace: record.namespace,
            default_yaml: record.default_yaml,
            version: record.version,
            label_check: label_check,
            owned_by: record.owned_by,
            customer_addon: record.customer_addon === 'true',
            chart: record.chart,
            optional_values: optional_values,
            credential_fields: credential_fields,
            secret_command: record.secret_command,
            doc_reference: record.doc_reference
          }
        })
      }
      console.log('CSV seed completed!')
    }
  } catch (error) {
    console.error('Error seeding data:', error)
    process.exit(1)
  } finally {
    await prisma.$disconnect()
  }
}

main()