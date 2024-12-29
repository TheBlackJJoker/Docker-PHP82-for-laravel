<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="scroll-smooth">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Tytuł</title>
    <meta name="description" content="Opis">

    <link rel="icon" href="#" type="image/svg+xml"> <!-- asset('assets/img/logo.svg') -->


    <link rel="stylesheet" href="{{ asset('assets/css/style.css') }}">
    @vite(['resources/css/app.css', 'resources/js/app.js'])

</head>
<body>
    <div class="text-center w-full font-bold text-lg text">test</div>
</body>
</html>
