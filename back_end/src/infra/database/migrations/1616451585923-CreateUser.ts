import { MigrationInterface, QueryRunner, Table } from "typeorm";

export default class CreateUser1616451585923 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.createTable(new Table({
            name: 'users',
            columns: [
                {
                    name: 'user_id',
                    type: 'uuid',
                    isPrimary: true,
                    generationStrategy: 'uuid',
                    default: 'uuid_generate_v4()'
                },
                {
                    name: 'first_name',
                    type: 'varchar'
                },
                {
                    name: 'last_name',
                    type: 'varchar'
                },
                {
                    name: 'user_name',
                    type: 'varchar',
                    isNullable: false,
                    isUnique: true
                },
                {
                    name: 'email',
                    type: 'varchar',
                    isUnique: true
                },
                {
                    name: 'password',
                    type: 'varchar'
                },
                {
                    name: 'curso',
                    type: 'varchar'
                },
                {
                    name: 'periodo',
                    type: 'numeric'
                },
                {
                    name: 'ano_curso',
                    type: 'numeric'
                },
                {
                    name: 'dt_nascimento',
                    type: 'date'
                },
                {
                    name: 'g_id',
                    type: 'varchar'
                },
                {
                    name: 'pending',
                    type: 'boolean',
                    default: true
                },
                {
                    name: 'admin',
                    type: 'boolean',
                    default: false
                },
                {
                    name: 'created_at',
                    type: 'timestamp',
                    default: 'now()'
                },
                {
                    name: 'updated_at',
                    type: 'timestamp',
                    default: 'now()'
                }
            ]
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.dropTable('users');
    }

}
