<?php

namespace Database\Seeders;

use Carbon\Carbon;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MemberSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $data = $this->seedData();
        DB::table('members')->insertOrIgnore($data);
    }

    private function seedData()
    {
        $currentTime = Carbon::now();
        return [
            [
                'id'    => 1,
                'first_name'    => 'Default',
                'last_name'     => 'System',
                'deleted_at'    => null,
                'created_at'    => $currentTime,
                'updated_at'    => $currentTime
            ],
            [
                'id'    => 2,
                'first_name'    => 'Yinghua',
                'last_name'     => 'Chai',
                'deleted_at'    => null,
                'created_at'    => $currentTime,
                'updated_at'    => $currentTime
            ]
        ];
    }
}
