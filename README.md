# Article Feed — Take Home Test

A Flutter "Save for later" feature built on top of the provided starter code.

## Running the app

```bash
flutter pub get
flutter run
```

## Project structure

The app follows Clean Architecture, split into `core` (shared infrastructure) and a `features/articles` slice with the standard data / domain / presentation layers.

```
lib/
  main.dart                                        # Entry point — init DI then runApp
  app.dart                                         # MaterialApp root

  core/
    di/injection_container.dart                    # GetIt service locator wiring
    error/
      exceptions.dart                              # Data-layer exceptions
      failures.dart                                # Domain-layer failures (Either)
    usecases/usecase.dart                          # Base UseCase + NoParams
    utils/
      app_constants.dart                           # App-wide constants
      app_theme.dart                               # ThemeData

  features/articles/
    data/
      datasources/articles_remote_datasource.dart  # MockArticlesRemoteDataSource
      models/
        article_model.dart                         # Article DTO + fromJson/toEntity
        save_result_model.dart                     # SaveResult DTO
      repositories/articles_repository_impl.dart   # Implements ArticlesRepository

    domain/
      entities/
        article.dart                               # Article entity
        save_result.dart                           # SaveResult entity
      repositories/articles_repository.dart        # Abstract repository contract
      usecases/
        get_articles_usecase.dart                  # Returns Either<Failure, List<Article>>
        save_article_usecase.dart                  # Returns Either<Failure, SaveResult>

    presentation/
      bloc/
        articles/
          articles_cubit.dart                      # ArticlesCubit — loads the feed
          articles_state.dart                      # Initial | Loading | Loaded | Error
        save_article/
          save_article_cubit.dart                  # SaveArticleCubit — owns save flow
          save_article_state.dart                  # Initial | Loading | Success | Failure
      pages/feed_page.dart                         # ListView screen
      widgets/article_card.dart                    # ArticleCard with BlocBuilder
```

---

## Part 2 — API Design

- For the Endpoint I would use POST /articles/{articleId}/saves to create a new entry to the `saved articles table`. 

- The user is identified from the auth token. No request body needed. The response shape would be below.

- Each entry in the `saved articles table` will have a userId, articleId and a savedAt data per each saved entry.

- When fetching articles per user with save state, the `articles table` complete with all articles will be joined with the `saved articles table`. Each entry with matching userId and articleId will be returned with a 'saved' parameter.

- I would enforce a UNIQUE contraint in the `saved articles table` so no duplicate userId and articleId will be saved. If the pair already exists, it should return a 200 OK since in context, it is still saved and that's the only data that the user needs. This will prevent duplicate entries from happening

-  To ensure validity of data, a save request should be revalidated with the `articles table` before appending the entry to the `saved articles table`. It should first be checked if the article is still valid and existing from the `'main articles table` before saving.

- For the response shape and data schema, I would design it as shown below;

### API Response

201 Created — save succeeded or 200 OK — already saved (both responses means that the article is saved to the user which is the only important data)

```json
{
  "id": "sa_abc123",
  "userId": "u_42",
  "articleId": "a1",
  "savedAt": "2025-06-04T10:30:00Z"
}
```

**401 Unauthorized** — missing or invalid auth token

```json
{ "error": "UNAUTHORIZED", "message": "Authentication required." }
```

**404 Not Found** — article doesn't exist or has been deleted

```json
{ "error": "ARTICLE_NOT_FOUND", "message": "This article is no longer available." }
```


**500 Internal Server Error** — server error

```json
{ "error": "INTERNAL_SERVER_ERROR", "message": "{error message based on backend error}" }
```

### Schema

**articles** table (all articles for all users)

| column       | type         | notes          |
|--------------|--------------|----------------|
| id           | UUID / PK    |                |
| title        | VARCHAR(255) |                |
| author       | VARCHAR(100) |                |
| preview      | TEXT         |                |
| deleted_at   | TIMESTAMPTZ  | soft-delete    |
| created_at   | TIMESTAMPTZ  |                |

**saved_articles** table (list of articles saved by all users)

| column      | type        | notes                                      |
|-------------|-------------|--------------------------------------------|
| id          | UUID / PK   | generated                                  |
| user_id     | UUID / FK   | → users.id, ON DELETE CASCADE              |
| article_id  | UUID / FK   | → articles.id, ON DELETE CASCADE           |
| saved_at    | TIMESTAMPTZ | default NOW()                              |

```sql
UNIQUE (user_id, article_id)        -- enforces deduplication at the DB level
INDEX  (user_id, saved_at DESC)     -- makes fetching a user's saved feed fast
```

The `ON DELETE CASCADE` on `article_id` means deleting an article automatically removes all its saves — no orphaned rows.

## Part 3 — My Thinking

### App Structure

- For this app, I used the lightweight version of Bloc which is Cubit since it is simple and straightforward. For more complex features with more complex state management, I would use Bloc. 

- I use `Bloc/Cubit since it decouples the UI from the business logic. With this, I can structer it better with separate layers of data, domain and presentation.

- For a large greenfield project, I would still stick with Bloc. It comes with more boilerplate but this would make the pattern predictable and easier to understand. When the team scales and new developers are added, the boilerplate would make it easier to understand and follow. This boilerplate would introduce better structure and consistency as it scales.

- Dependency Injection is handled by get_it via a single `setupDependencies()` call at startup. Cubits are registered as factories (a fresh instance each time) while the repository and data source are singletons.

- I planned on using full on Bloc for the state management but since it is very straightforward and simple, I decided that showing cubit would showcase how I strategize to make sure the app is as simple as possible.

- With additional time, I would write unit tests for better code architecture. I would also improve the UI/UX by improving the design and adding more feedback (haptic/sound) tho that would usually be designed by the UI/UX designers.

### Assumptions I'd normally clarify

- Can we 'unsave' an article? I assumed we can unsave what is saved since that is the usual functionality of lists like this. 

- Is the saving persistent? how? I assumed the saving is persistent but it won't show in the code. I assumed that the saving will be saved in the backend so no local state saving is implemented

- How do we handle errors? I added a simple error message in the article cards but I would clarify this with UI/UX on how it should be handled.
